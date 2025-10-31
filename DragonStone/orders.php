<?php
$title='My Orders';
require __DIR__.'/header.php';
require_user(); // must be logged in

// get current user id
$me = user_find_by_email(auth_user()['email']);
$uid = $me ? (int)$me['id'] : 0;

$list = $uid ? orders_by_user($uid) : [];
?>
<h1>My Orders</h1>

<?php if(!$list): ?>
  <p>You have no orders yet.</p>
<?php else: ?>
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
  <tr><th>#</th><th>Total</th><th>Date</th><th></th></tr>
  <?php foreach($list as $o): ?>
  <tr>
    <td><?= (int)$o['id'] ?></td>
    <td>R<?= number_format((float)$o['total_amount'],2) ?></td>
    <td><?= e($o['placed_at']) ?></td>
    <td><a class="btn" href="<?= url('order.php?id='.(int)$o['id']) ?>">View</a></td>
  </tr>
  <?php endforeach; ?>
</table>
<?php endif; ?>

<?php require __DIR__.'/footer.php'; ?>
