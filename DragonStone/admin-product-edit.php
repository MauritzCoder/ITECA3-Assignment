<?php
//declare(strict_types=1);

$title = 'Edit Product';
require __DIR__ . '/header.php'; // header.php should already pull in config.php + functions.php

// --- Access control: admins only ---
if (!is_admin()) {
  echo "<p class='error'>Admins only.</p>";
  require __DIR__ . '/footer.php';
  exit;
}

// --- Get product ID from query string ---
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if ($id <= 0) {
  echo "<p class='error'>Invalid product ID.</p>";
  require __DIR__ . '/footer.php';
  exit;
}

$errors = [];
$saved  = false;

// --- Handle form submit ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $name        = trim($_POST['name'] ?? '');
  $price       = (float)($_POST['price'] ?? 0);
  $stock_qty   = (int)($_POST['stock_qty'] ?? 0);
  $category_id = (int)($_POST['category_id'] ?? 0);
  $img         = trim($_POST['img'] ?? '');
  $desc        = trim($_POST['desc'] ?? '');

  if ($name === '' || $price <= 0) {
    $errors[] = 'Name and positive price required.';
  }

  if (!$errors) {
    if (product_update($id, $name, $price, $img, $desc, $stock_qty, $category_id)) {
      $saved = true;
      // refresh data from DB/JSON
      $product = product_get($id);
    } else {
      $errors[] = 'Could not update product (DB error).';
    }
  }

  // If validation fails, keep posted values in $product
  if (!$saved) {
    $product = [
      'id'          => $id,
      'name'        => $name,
      'price'       => $price,
      'img'         => $img,
      'description' => $desc,
      'stock_qty'   => $stock_qty,
      'category_id' => $category_id,
    ];
  }
} else {
  // First load
  $product = product_get($id);
}

if (!$product) {
  echo "<p class='error'>Product not found.</p>";
  require __DIR__ . '/footer.php';
  exit;
}

// --- Load categories for the dropdown ---
$cats = categories_all();
?>

<h1>Edit Product #<?= (int)$product['id'] ?></h1>

<?php if ($saved): ?>
  <p class="ok">Product updated successfully.</p>
<?php endif; ?>

<?php if ($errors): ?>
  <ul class="error">
    <?php foreach ($errors as $msg): ?>
      <li><?= e($msg) ?></li>
    <?php endforeach; ?>
  </ul>
<?php endif; ?>

<form method="post" class="grid" style="grid-template-columns:1fr 1fr">
  <div class="field">
    <label>Name</label>
    <input name="name" value="<?= e($product['name']) ?>" required>
  </div>

  <div class="field">
    <label>Price</label>
    <input name="price" type="number" step="0.01"
           value="<?= e($product['price']) ?>" required>
  </div>

  <div class="field">
    <label>Category</label>
    <select name="category_id" required>
      <option value="">-- Select category --</option>
      <?php foreach ($cats as $c): ?>
        <option value="<?= (int)$c['id'] ?>"
          <?= ((int)$c['id'] === (int)$product['category_id']) ? 'selected' : '' ?>>
          <?= e($c['name']) ?>
        </option>
      <?php endforeach; ?>
    </select>
  </div>

  <div class="field">
    <label>Stock Quantity</label>
    <input name="stock_qty" type="number" step="1" min="0"
           value="<?= e($product['stock_qty']) ?>" required>
  </div>

  <div class="field" style="grid-column:1/-1">
    <label>Image URL</label>
    <input name="img" value="<?= e($product['img']) ?>">
  </div>

  <div class="field" style="grid-column:1/-1">
    <label>Description</label>
    <textarea name="desc" rows="3"><?= e($product['description']) ?></textarea>
  </div>

  <div style="grid-column:1/-1">
    <button class="btn">Save changes</button>
    <a class="btn" href="<?= url('admin.php') ?>">Back to admin</a>
  </div>
</form>

<?php require __DIR__ . '/footer.php'; ?>