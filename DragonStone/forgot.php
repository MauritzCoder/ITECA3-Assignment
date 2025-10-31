<?php $title='Forgot Password'; require __DIR__.'/header.php'; require_guest(); ?>
<h1>Forgot Password</h1>
<p>This demo does not send email. In a real app you’d generate a token and email a reset link.</p>
<form method="post" style="max-width:360px">
  <div class="field"><label>Email</label><input name="email"></div>
  <button class="btn">Pretend to send link</button>
</form>
<?php require __DIR__.'/footer.php'; ?>
