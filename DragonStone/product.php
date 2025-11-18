<?php $title = 'Product';
require __DIR__ . '/header.php';
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if (!$p = product_find($id)) {
  echo "<p class='error'>Product not found.</p>";
  require __DIR__ . '/footer.php';
  exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  cart_add($p['id'], max(1, (int)($_POST['qty'] ?? 1)));
  flash('ok', 'Added to cart');
  header('Location: ' . url('cart.php'));
  exit;
}
?>
<article class="grid" style="grid-template-columns: 1.2fr 1fr;">
  <div><img src="<?= e($p['img']) ?>" style="width:100%;max-height:340px;object-fit:cover"></div>
  <div>
    <h1 style="color: #ffffffff;"><?= e($p['name']) ?></h1>
    <p>R<?= number_format($p['price'], 2) ?></p>

    <?php
    $carbon = isset($p['carbon_per_unit']) ? (float)$p['carbon_per_unit'] : null;
    ?>


    <?php if ($carbon !== null && $carbon > 0): ?>
      <p style="font-size:.9rem;color:#555;margin-top:.3rem;">
        <strong>Estimated footprint:</strong>
        <?= number_format($carbon, 0) ?> g CO₂e per unit
        (≈ <?= number_format($carbon / 1000, 2) ?> kg per 10 units)
      </p>
    <?php else: ?>
      <p style="font-size:.8rem;color:#888;margin-top:.3rem;">
        <em>Carbon footprint data for this product is not available yet.</em>
      </p>
    <?php endif; ?>
    <p><?= e($p['description']) ?></p>
    <form method="post">
      <div class="field"><input type="number" name="qty" min="1" value="1"></div>
      <button class="btn">Add to cart</button>
    </form>
  </div>
</article>

<script>
  //showing how much the product would cost If you take more than one
  document.addEventListener('DOMContentLoaded', function() {
    const qty = document.querySelector('input[name="qty"]');
    const priceEl = document.querySelector('p'); // the first price <p> on the page
    if (!qty || !priceEl) return;

    // Extract numeric price from "R123.45"
    const priceMatch = priceEl.textContent.replace(/[^\d.]/g, '');
    const unitPrice = parseFloat(priceMatch || '0');

    const totalHint = document.createElement('div');
    totalHint.style.marginTop = '.25rem';
    priceEl.insertAdjacentElement('afterend', totalHint);

    function renderTotal() {
      let n = parseInt(qty.value || '1', 10);
      if (isNaN(n) || n < 1) n = 1;
      qty.value = n; // clamp to >=1
      totalHint.textContent = 'Line total: R' + (unitPrice * n).toFixed(2);
    }

    qty.addEventListener('input', renderTotal);
    renderTotal(); // initial
  });
</script>
<?php require __DIR__ . '/footer.php'; ?>