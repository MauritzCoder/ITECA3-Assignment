<?php $title='Admin'; 
require __DIR__.'/header.php'; 
if(!is_admin()){ echo "<p class='error'>Admins only.</p>"; 
require __DIR__.'/footer.php'; exit; }

$json = __DIR__.'/products.json';
$items = products_all();

$items = products_all();

if($_SERVER['REQUEST_METHOD']==='POST'){
  $act = $_POST['act'] ?? '';
  if($act === 'create'){//getting varibals form users at assigning them
    $name = trim($_POST['name'] ?? '');
    $price = (float)($_POST['price'] ?? 0);
    $img = trim($_POST['img'] ?? '');
    $stock_qty = (float)($_POST['stock_qty'] ?? 0);

    $desc = trim($_POST['description'] ?? '');

    if($name !== '' && $price > 0){//validate if admin have enterd a price
      if (product_create($name,$price,$img,$desc,$stock_qty)){
        flash('ok','Product created');
      } else {
        flash('err','DB error creating product');
      }
    } else {
      flash('err','Name and positive price required');
    }
    header('Location: '.url('admin.php')); exit;
  }
  if($act === 'delete'){
    $id = (int)($_POST['id'] ?? 0);
    if ($id && product_delete($id)){
      flash('ok','Product deleted');
    } else {
      flash('err','DB error deleting product');
    }
    header('Location: '.url('admin.php')); exit;
  }
}

// refresh list after modifications
$items = products_all();
?>
<h1>Admin: Products</h1>

<h2>Add product</h2>
<form method="post" class="grid" style="grid-template-columns:1fr 1fr">
  <input type="hidden" name="act" value="create">
  <div class="field"><label>Name</label><input name="name"></div>
  <div class="field"><label>Price</label><input name="price" type="number" step="0.01"></div>
  <div class="field"><label>Stock Quantity</label><input name="stock_qty" type="number" step="1"></div>
  <div class="field" style="grid-column:1/-1"><label>Image URL</label><input name="img"></div>
  <div class="field" style="grid-column:1/-1"><label>Description</label><textarea name="desc" rows="3"></textarea></div>
  <div><button class="btn">Add</button></div>
</form>

<hr>
<h2>Recent Orders</h2>
<?php
global $mysqli, $USE_DB;
if($USE_DB && $mysqli):

  // STRICT / ONLY_FULL_GROUP_BY safe query; also counts total quantity not just rows
  $q = "
    SELECT
      o.user_id,
      o.customer_name,
      o.email,
      o.total_amount,
      o.placed_at,
      COALESCE(SUM(oi.qty),0) AS items
    FROM orders o
    LEFT JOIN order_items oi ON oi.order_id = o.id
    GROUP BY o.id, o.customer_name, o.email, o.total_amount, o.placed_at
    ORDER BY o.id DESC
    LIMIT 25
  ";

  $res = mysqli_query($mysqli, $q);
  if (!$res):
?>
  <p class="error">Query failed: <?= e(mysqli_error($mysqli)) ?></p>
<?php else: ?>
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
  <tr>
    <th>#</th>
    <th>Customer</th>
    <th>Email</th>
    <th>Items</th>
    <th>Total</th>
    <th>Date</th>
  </tr>
  <?php while($row = mysqli_fetch_assoc($res)): ?>
  <tr>
    <td><?= (int)$row['user_id'] ?></td>
    <td><?= e($row['customer_name']) ?></td>
    <td><?= e($row['email']) ?></td>
    <td><?= (int)$row['items'] ?></td>
    <td>R<?= number_format((float)$row['total_amount'], 2) ?></td>
    <td><?= e($row['placed_at']) ?></td>
  </tr>
  <?php endwhile; ?>
</table>
<?php endif; else: ?>
<p class="error">DB not active.</p>
<?php endif; ?>


<h2>Existing</h2>
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse;width:100%">
<tr><th>ID</th><th>Name</th><th>Price</th><th>Stock Quantity</th><th>Preview</th><th></th></tr>
<?php foreach($items as $p): ?>
<tr>
  <td><?= (int)$p['id']?></td>
  <td><?= e($p['name'])?></td>
  <td>R<?= number_format($p['price'],2)?></td>
  <td><?= ($p['stock_qty'])?></td>
  <td><img src="<?= e($p['img'])?>" style="height:40px"></td>
  <td>
    <form method="post" style="display:inline">
      <input type="hidden" name="act" value="delete">
      <button class="btn" name="id" value="<?= (int)$p['id']?>">Delete</button>
    </form>
    <a class="btn" href="<?= url('product.php?id='.(int)$p['id'])?>">View</a>
  </td>
</tr>
<?php endforeach; ?>
</table>
<?php require __DIR__.'/footer.php'; ?>
