<?php $title='Checkout'; require __DIR__.'/header.php'; $errors=[];
$name=$email=$addr='';

if($_SERVER['REQUEST_METHOD']==='POST'){
  // sanitize
 
  $name  = trim($_POST['name']??'');
  $email = trim($_POST['email']??'');
  $addr  = trim($_POST['address']??'');

  if($name==='') $errors['name']='Name is required';
  if($email==='' || !filter_var($email,FILTER_VALIDATE_EMAIL)) $errors['email']='Valid email required';
  if($addr==='') $errors['address']='Address is required';

  $items = cart_items();
  //echo "test1" .var_dump($items);
  if (!$items) { $errors['cart'] = 'Cart is empty'; }
 
  if (!$errors){
    $uid = auth_user() ? null : null; // keep it simple: guest checkout; or set user id if you want:
    if (auth_user()){
	  // optional: load DB user id
	 $u = user_find_by_email(auth_user()['email']);
   	 $uid = $u ? (int)$u['id'] : null;
    }
    //echo "uid:".$uid . "name:".$name."email:". $email ."addr". $addr ."items:".var_dump($items);

    $order_id = order_create($uid, $name, $email, $addr, $items);
   // echo "test2" .$order_id;

    if ($order_id){
	  // clear cart
    //echo "test3" .$order_id;
	  $_SESSION['cart'] = [];
	  flash('ok','Order placed. Your order number is #'.$order_id);
	  header('Location: '.url('index.php')); exit;
  } else {
	$errors['db'] = 'Could not save order. Please try again.';
  }
}
  
  
}
?>
<h1>Checkout</h1>
<form method="post" style="max-width:520px">
  <div class="field">
    <label>Name</label>
    <input name="name" value="<?= e($name)?>">
    <?php if(isset($errors['name'])): ?><div class="error"><?= e($errors['name'])?></div><?php endif; ?>
  </div>
  <div class="field">
    <label>Email</label>
    <input name="email" value="<?= e($email)?>">
    <?php if(isset($errors['email'])): ?><div class="error"><?= e($errors['email'])?></div><?php endif; ?>
  </div>
  <div class="field">
    <label>Delivery Address</label>
    <textarea name="address" rows="4"><?= e($addr)?></textarea>
    <?php if(isset($errors['address'])): ?><div class="error"><?= e($errors['address'])?></div><?php endif; ?>
  </div>
  <button class="btn">Place order</button>
</form>
<?php require __DIR__.'/footer.php'; ?>
