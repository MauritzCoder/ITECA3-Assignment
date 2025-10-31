<?php $title='Cart'; require __DIR__.'/header.php';
if(isset($_POST['remove'])){ cart_remove((int)$_POST['remove']); flash('ok','Item removed'); header('Location: '.url('cart.php')); exit; }
$items = cart_items(); $total = cart_total();
?>
<h1>Your Cart</h1>
<?php if(!$items): ?><p>Cart is empty.</p>
<?php else: ?>
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse;width:100%">
  <tr><th>Product</th><th>Price</th><th>Qty</th><th>Line</th><th></th></tr>
  <?php foreach($items as $it): ?>
  <tr>
    <td><?= e($it['name'])?></td>
    <td>R<?= number_format($it['price'],2)?></td>
    <td><?= (int)$it['qty']?></td>
    <td>R<?= number_format($it['price']*$it['qty'],2)?></td>
    <td>
      <form method="post" style="display:inline">
        <button class="btn" name="remove" value="<?= (int)$it['id']?>">Remove</button>
      </form>
    </td>
  </tr>
  <?php endforeach; ?>
  <tr><td colspan="3" align="right"><b>Total</b></td><td><b>R<?= number_format($total,2)?></b></td><td></td></tr>
</table>
<p><a class="btn" href="<?= url('checkout.php')?>">Checkout</a></p>
<?php endif; ?>
<?php require __DIR__.'/footer.php'; ?>
