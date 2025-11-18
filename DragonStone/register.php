<?php $title='Register'; require __DIR__.'/header.php'; require_guest();
$msg='';
if($_SERVER['REQUEST_METHOD']==='POST'){
  $name  = trim($_POST['name']??'');
  $email = trim($_POST['email']??'');
  $pass  = $_POST['password'] ?? '';

  if ($name && $email && $pass){
    if (user_find_by_email($email)) {
      $msg = 'Email already registered';
    } else {
      if (user_create($name,$email,$pass)){
        $_SESSION['user']=['id'=> $u['id'],'email'=>$email,'name'=>$name,'role'=>'user'];
        flash('ok','Registered.');
        header('Location: '.url('index.php')); exit;
      } else {
        $msg = 'Registration failed (DB)';
      }
    }
  } else {
    $msg='All fields required';
  }
}
?>
<h1>Register</h1>
<form method="post" style="max-width:420px">
  <div class="field"><label>Name</label><input name="name"></div>
  <div class="field"><label>Email</label><input name="email"></div>
  <div class="field"><label>Password</label><input type="password" name="password"></div>
  <?php if($msg): ?><div class="error"><?= e($msg)?></div><?php endif; ?>
  <button class="btn">Create account</button>
</form>
<?php require __DIR__.'/footer.php'; ?>
