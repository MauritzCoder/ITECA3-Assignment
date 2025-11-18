<?php $title='Login'; require __DIR__.'/header.php'; require_guest();
$msg='';
if($_SERVER['REQUEST_METHOD']==='POST'){
  $email = trim($_POST['email']??'');
  $pass  = $_POST['password'] ?? '';

  if ($email && $pass){
    if ($u = user_find_by_email($email)){
      if (password_verify($pass, $u['password_hash'])){
        $_SESSION['user']=['id'=> $u['id'],'email'=>$u['email'],'name'=>$u['name'],'role'=>$u['role']];
        flash('ok','Logged in.');
        header('Location: '.url('index.php'));  

        exit;
      }
    }
    $msg='Invalid credentials';
  } else {
    $msg='All fields required';
  }
}
?>
<h1>Login</h1>
<form method="post" style="max-width:360px">
  <div class="field"><label>Email</label><input name="email"></div>
  <div class="field"><label>Password</label><input type="password" name="password"></div>
  <?php if($msg): ?><div class="error"><?= e($msg)?></div><?php endif; ?>
  <button class="btn">Login</button>
</form>
<p><a href="<?= url('forgot.php')?>">Forgot password?</a></p>
<?php require __DIR__.'/footer.php'; ?>
