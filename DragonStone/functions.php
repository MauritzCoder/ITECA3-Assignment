<?php
// HTML escape
function e($s){ return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }

// ---------- Product access (DB first, fallback to array) ----------
function products_all(){
  global $USE_DB, $mysqli, $SEED_PRODUCTS;
  $json = __DIR__.'/products.json';

  // 1) Prefer DB when enabled and connected
  if ($USE_DB && $mysqli) {
    $res = mysqli_query($mysqli, "SELECT id,name,price,img,description,stock_qty FROM products");
    if ($res){
      $rows=[]; while($r=mysqli_fetch_assoc($res)) $rows[]=$r;
      if ($rows) return $rows;
    }
  }

  // 2) Otherwise fallback to JSON file if present
  if (file_exists($json)) {
    $arr = json_decode(file_get_contents($json), true);
    if (is_array($arr)) return $arr;
  }

  // 3) Finally fallback to seed array
  return $SEED_PRODUCTS;
}


function product_find($id){
  $id = (int)$id;
  foreach (products_all() as $p) if ((int)$p['id']===$id) return $p;
  return null;
}

// ---------- Cart (sessions) ----------
function cart_get(){ return $_SESSION['cart'] ?? []; }
function cart_set($cart){ $_SESSION['cart'] = $cart; }
function cart_add($id,$qty=1){
  $id=(int)$id; $qty=(int)$qty;
  $cart=cart_get(); $cart[$id]=($cart[$id]??0)+$qty; cart_set($cart);
}
function cart_remove($id){
  $id=(int)$id; $cart=cart_get(); unset($cart[$id]); cart_set($cart);
}
function cart_items(){
  $items=[]; foreach (cart_get() as $id=>$qty){ if ($p=product_find($id)){ $p['qty']=$qty; $items[]=$p; } }
  return $items;
}
function cart_total(){
  $sum=0; foreach(cart_items() as $it) $sum += $it['price']*$it['qty']; return $sum;
}

// ---------- Auth (sessions only) ----------
// ---------- Auth (sessions only) ----------
function auth_user(){ return $_SESSION['user'] ?? null; }
function require_guest(){ if(auth_user()) header('Location: '.url('index.php')); }
function require_user(){ if(!auth_user()) header('Location: '.url('login.php')); }


// Role helpers (keeps existing 'admin' working)
function is_admin(){ return auth_user() && (auth_user()['role'] ?? '') === 'admin'; }
function is_manager(){ return auth_user() && in_array(auth_user()['role'] ?? '', ['manager','admin'], true); }
function is_staff(){ return auth_user() && in_array(auth_user()['role'] ?? '', ['staff','manager','admin'], true); }

/**
 * Simple role gate:
 *   require_role(['staff','manager','admin']);
 *   require_role(['manager','admin']);
 *   require_role(['admin']);
 */
function require_role(array $roles){
  if (!auth_user() || !in_array(auth_user()['role'] ?? '', $roles, true)) {
    http_response_code(403);
    echo "<p class='error'>Forbidden – insufficient privileges.</p>";
    require __DIR__ . '/footer.php';
    exit;
  }
}


// ---------- Flash ----------
function flash($key,$val=null){
  if ($val===null){ $v=$_SESSION['flash'][$key]??null; unset($_SESSION['flash'][$key]); return $v; }
  $_SESSION['flash'][$key]=$val;
}


/** USERS **/
function user_find_by_email($email){
  global $mysqli, $USE_DB;
  if(!$USE_DB || !$mysqli) return null;
  $stmt = mysqli_prepare($mysqli, "SELECT id,name,email,password_hash,role FROM users WHERE email=?");
  mysqli_stmt_bind_param($stmt, "s", $email);
  mysqli_stmt_execute($stmt);
  $res = mysqli_stmt_get_result($stmt);
  return $res ? mysqli_fetch_assoc($res) : null;
}

function user_create($name,$email,$password){
  global $mysqli, $USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  $hash = password_hash($password, PASSWORD_BCRYPT);
  $stmt = mysqli_prepare($mysqli, "INSERT INTO users(name,email,password_hash,role) VALUES(?,?,?,'customer')");//set new user defualt as customer for safty
  mysqli_stmt_bind_param($stmt, "sss", $name, $email, $hash);
  return mysqli_stmt_execute($stmt);
}

/** PRODUCTS ADD (Admin create/delete minimal) **/
function product_create($name,$price,$img,$desc,$stock_qty){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  $stmt = mysqli_prepare($mysqli, "INSERT INTO products(name,price,stock_qty,img,description) VALUES(?,?,?,?,?)");
  mysqli_stmt_bind_param($stmt, "sdiss", $name,$price,$stock_qty,$img,$desc);
  return mysqli_stmt_execute($stmt);
}
function product_delete($id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  $id=(int)$id;
  $stmt = mysqli_prepare($mysqli, "DELETE FROM products WHERE id=?");
  mysqli_stmt_bind_param($stmt, "i", $id);
  return mysqli_stmt_execute($stmt);
}

/** ORDERS **/
function order_create($user_id,$name,$email,$address,$items){
  // $items = array of ['id','name','price','qty']
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;

  // compute total
  $total = 0.0;
  foreach($items as $it){ $total += ((float)$it['price'] * (int)$it['qty']); }

  mysqli_begin_transaction($mysqli);
  try {
    // insert order
    $stmt = mysqli_prepare($mysqli, "INSERT INTO orders(user_id,customer_name,email,delivery_address,total_amount) VALUES(?,?,?,?,?)");
    if ($user_id===null) { $tmp = null; mysqli_stmt_bind_param($stmt, "isssd", $tmp,$name,$email,$address,$total); }
    else { mysqli_stmt_bind_param($stmt, "isssd", $user_id,$name,$email,$address,$total); }
    mysqli_stmt_execute($stmt);
    $order_id = mysqli_insert_id($mysqli);

    // insert items
    $stmt2 = mysqli_prepare($mysqli, "INSERT INTO order_items (order_id,product_id,name,unit_price,qty) VALUES(?,?,?,?,?)");
    foreach($items as $it){
      $pid=(int)$it['id']; $n=$it['name']; $p=(float)$it['unit_price']; $q=(int)$it['qty'];
      mysqli_stmt_bind_param($stmt2, "iisdi", $order_id,$pid,$n,$p,$q);
      mysqli_stmt_execute($stmt2);
    }

    mysqli_commit($mysqli);
    return $order_id;
  } catch (Throwable $e){
    mysqli_rollback($mysqli);
    return false;
  }
}


function orders_by_user($user_id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return [];
  $user_id = (int)$user_id;
  $sql = "SELECT id, total_amount, placed_at FROM orders WHERE user_id=? ORDER BY id DESC";
  $stmt = mysqli_prepare($mysqli, $sql);
  mysqli_stmt_bind_param($stmt, "i", $user_id);
  mysqli_stmt_execute($stmt);
  $res = mysqli_stmt_get_result($stmt);
  $rows = [];
  while($res && ($row = mysqli_fetch_assoc($res))) $rows[] = $row;
  return $rows;
}

function order_with_items_for_user($order_id, $user_id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return null;
  $order_id = (int)$order_id; $user_id=(int)$user_id;

  // Load order (ownership enforced)
  $stmt = mysqli_prepare($mysqli, "SELECT id, customer_name, email, delivery_address, total_amount, placed_at 
                                   FROM orders WHERE id=? AND user_id=?");
  mysqli_stmt_bind_param($stmt, "ii", $order_id, $user_id);
  mysqli_stmt_execute($stmt);
  $order = mysqli_stmt_get_result($stmt);
  $order = $order ? mysqli_fetch_assoc($order) : null;
  if(!$order) return null;

  // Load items
  $stmt2 = mysqli_prepare($mysqli, "SELECT product_id, name, unit_price, qty 
                                    FROM order_items WHERE order_id=? ORDER BY id ASC");
  mysqli_stmt_bind_param($stmt2, "i", $order_id);
  mysqli_stmt_execute($stmt2);
  $res2 = mysqli_stmt_get_result($stmt2);
  $items = [];
  while($res2 && ($row = mysqli_fetch_assoc($res2))) $items[] = $row;

  $order['items'] = $items;
  return $order;
}

// ---------------------------------------------------
        //community blog
//----------------------------------------------------
/* ---------- Community & EcoPoints Config ---------- */
const ECOPOINTS_POST     = 10;  // earn for a published post
const ECOPOINTS_COMMENT  = 3;   // earn for a comment
const ECOPOINTS_UPVOTE   = 1;   // optional: when your post is upvoted (not implemented here)

/* ---------- EcoPoints ---------- */
function ecopoints_add($user_id, $delta, $reason, $ref_type=null, $ref_id=null){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  $sql="INSERT INTO ecopoints_ledger(user_id,delta,reason,ref_type,ref_id) VALUES (?,?,?,?,?)";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"i ss si", $user_id, $delta, $reason, $ref_type, $ref_id);
  return mysqli_stmt_execute($st);
}

function ecopoints_balance($user_id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return 0;
  $sql="SELECT COALESCE(SUM(delta),0) FROM ecopoints_ledger WHERE user_id=?";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"i",$user_id);
  mysqli_stmt_execute($st);
  mysqli_stmt_bind_result($st,$bal);
  mysqli_stmt_fetch($st);
  return (int)$bal;
}

/* ---------- Slug helper ---------- */
function slugify($s){
  $s = preg_replace('~[^\pL\d]+~u','-', $s);
  $s = trim($s,'-');
  $s = iconv('UTF-8','ASCII//TRANSLIT',$s);
  $s = strtolower($s);
  $s = preg_replace('~[^-\w]+~','', $s);
  if (empty($s)) $s = 'post';
  return $s.'-'.substr(sha1(uniqid('',true)),0,6);
}

/* ---------- Forum: posts ---------- */
function forum_post_create($user_id,$title,$body,$tags=null){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  $slug = slugify($title);
  $sql="INSERT INTO forum_posts(user_id,title,slug,body,tags) VALUES (?,?,?,?,?)";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"issss",$user_id,$title,$slug,$body,$tags);
  if(!mysqli_stmt_execute($st)) return false;
  $post_id = mysqli_insert_id($mysqli);
  // award EcoPoints
  if($user_id) ecopoints_add($user_id, ECOPOINTS_POST, 'post', 'forum_post', $post_id);
  return $post_id;
}

function forum_posts_all($limit=20,$offset=0){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return [];
  $sql="SELECT p.*, u.name AS author 
        FROM forum_posts p 
        LEFT JOIN users u ON u.id=p.user_id
        WHERE is_published=1
        ORDER BY created_at DESC
        LIMIT ? OFFSET ?";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"ii",$limit,$offset);
  mysqli_stmt_execute($st);
  $res=mysqli_stmt_get_result($st);
  return mysqli_fetch_all($res, MYSQLI_ASSOC);
}

function forum_post_get($slug_or_id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return null;
  if(is_numeric($slug_or_id)){
    $sql="SELECT p.*, u.name AS author FROM forum_posts p LEFT JOIN users u ON u.id=p.user_id WHERE p.id=?";
    $st=mysqli_prepare($mysqli,$sql);
    mysqli_stmt_bind_param($st,"i",$slug_or_id);
  } else {
    $sql="SELECT p.*, u.name AS author FROM forum_posts p LEFT JOIN users u ON u.id=p.user_id WHERE p.slug=?";
    $st=mysqli_prepare($mysqli,$sql);
    mysqli_stmt_bind_param($st,"s",$slug_or_id);
  }
  mysqli_stmt_execute($st);
  $res=mysqli_stmt_get_result($st);
  return mysqli_fetch_assoc($res);
}

/* ---------- Forum: comments ---------- */
function forum_comment_create($post_id,$user_id,$body){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  $sql="INSERT INTO forum_comments(post_id,user_id,body) VALUES (?,?,?)";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"iis",$post_id,$user_id,$body);
  if(!mysqli_stmt_execute($st)) return false;
  // bump comments count
  mysqli_query($mysqli,"UPDATE forum_posts SET comments_cnt=comments_cnt+1 WHERE id=".(int)$post_id);
  // award points
  if($user_id) ecopoints_add($user_id, ECOPOINTS_COMMENT, 'comment', 'forum_comment', mysqli_insert_id($mysqli));
  return true;
}

function forum_comments_for($post_id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return [];
  $sql="SELECT c.*, u.name AS author 
        FROM forum_comments c 
        LEFT JOIN users u ON u.id=c.user_id
        WHERE c.post_id=?
        ORDER BY c.created_at ASC";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"i",$post_id);
  mysqli_stmt_execute($st);
  $res=mysqli_stmt_get_result($st);
  return mysqli_fetch_all($res, MYSQLI_ASSOC);
}

/* ---------- Forum: upvote (one per user) ---------- */
function forum_upvote($post_id,$user_id){
  global $mysqli,$USE_DB;
  if(!$USE_DB || !$mysqli) return false;
  // insert-ignore vote
  $sql="INSERT IGNORE INTO forum_votes(post_id,user_id,vote) VALUES (?,?,1)";
  $st=mysqli_prepare($mysqli,$sql);
  mysqli_stmt_bind_param($st,"ii",$post_id,$user_id);
  if(!mysqli_stmt_execute($st)) return false;
  if(mysqli_affected_rows($mysqli)>0){
    // count votes just for display; (optional: award author)
    mysqli_query($mysqli,"UPDATE forum_posts SET upvotes = (SELECT COUNT(*) FROM forum_votes WHERE post_id=".(int)$post_id.") WHERE id=".(int)$post_id);
  }
  return true;
}

