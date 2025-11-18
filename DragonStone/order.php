<?php
$title='Order';
require __DIR__.'/header.php';
require_user();

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

// current user
$me = user_find_by_email(auth_user()['email']);
$uid = $me ? (int)$me['id'] : 0;

$order = ($id && $uid) ? order_with_items_for_user($id, $uid) : null;
if(!$order){
  echo "<p class='error'>Order not found.</p>";
  require __DIR__.'/footer.php'; exit;
}


?>
<h1>Order #<?= (int)$order['id'] ?></h1>

<p><b>Customer:</b> <?= e($order['customer_name']) ?><br>
<b>Email:</b> <?= e($order['email']) ?><br>
<b>Address:</b> <?= nl2br(e($order['delivery_address'])) ?><br>
<b>Total:</b> R<?= number_format((float)$order['total_amount'],2) ?><br>
<?php if (!empty($order['carbon_grams']) && $order['carbon_grams'] > 0): ?>
  <?php
    $cg  = (float)$order['carbon_grams'];
    $ckg = $cg / 1000;
  ?>
  <p style="font-size:.9rem;color:#555;margin-top:.3rem;">
    <strong>Estimated order footprint:</strong>
    <?= number_format($ckg, 2) ?> kg CO₂e
    (<?= number_format($cg, 0) ?> g)
  </p>
<?php endif; ?>
<b>Date:</b> <?= e($order['placed_at']) ?></p>



<h3>Items</h3>
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
  <tr><th>Product</th><th>Price</th><th>Qty</th><th>Line Total</th></tr>
  <?php foreach($order['items'] as $it): ?>
  <tr>
    <td><?= e($it['name']) ?></td>
    <td>R<?= number_format((float)$it['unit_price'],2) ?></td>
    <td><?= (int)$it['qty'] ?></td>
    <td>R<?= number_format((float)$it['unit_price']*(int)$it['qty'],2) ?></td>
  </tr>
  <?php endforeach; ?>
</table>

<?php require __DIR__.'/footer.php'; ?>
