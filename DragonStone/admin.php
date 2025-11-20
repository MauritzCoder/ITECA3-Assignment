<?php $title = 'Admin';
require __DIR__ . '/header.php';

//access validation
if (!is_admin()) {
  echo "<p class='error'>Admins only.</p>";
  require __DIR__ . '/footer.php';
  exit;
}

$current = auth_user(); // current logged-in admin/manager

// Handle user role update
if (
  $_SERVER['REQUEST_METHOD'] === 'POST'
  && ($_POST['action'] ?? '') === 'update_user_role'
) {

  // Only full admins may change roles
  if (!is_admin()) {
    flash('err', 'Only admins can change user roles.');
    header('Location: ' . url('admin.php') . '#users');
    exit;
  }

  $uid  = (int)($_POST['user_id'] ?? 0);
  $role = trim((string)($_POST['role'] ?? ''));

  if ($uid <= 0) {
    flash('err', 'Invalid user id.');
    header('Location: ' . url('admin.php') . '#users');
    exit;
  }

  // Do not allow editing your own role (safety)
  if ($current && $current['id'] === $uid) {
    flash('err', 'You cannot change your own role.');
    header('Location: ' . url('admin.php') . '#users');
    exit;
  }

  if (user_update_role($uid, $role)) {
    flash('ok', 'User role updated.');
  } else {
    flash('err', 'Could not update user role.');
  }

  header('Location: ' . url('admin.php') . '#users');
  exit;
}


$json = __DIR__ . '/products.json';
$items = products_all();
// var_dump($_POST['category_id']);//testing if rigth value is send form the selecet categorys
// exit;
$items = products_all();
$cats = categories_all();   //get all categories for the dropdown
$users = users_all(); //getting all the users

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $act = $_POST['act'] ?? '';
  if ($act === 'create') { //getting varibals form users at assigning them
    $name = trim($_POST['name'] ?? '');
    $price = (float)($_POST['price'] ?? 0);
    $img = trim($_POST['img'] ?? '');
    $stock_qty = (float)($_POST['stock_qty'] ?? 0);
    $category_id = (int)($_POST['category_id'] ?? 0);
    $desc = trim($_POST['desc'] ?? '');

    if ($name !== '' && $price > 0) { //validate if admin have enterd a price
      if (product_create($name, $price, $img, $desc, $stock_qty, $category_id)) {
        flash('ok', 'Product created');
      } else {
        flash('err', 'DB error creating product');
      }
    } else {
      flash('err', 'Name and positive price required');
    }
    header('Location: ' . url('admin.php'));
    exit;
  }
  if ($act === 'delete') {
    $id = (int)($_POST['id'] ?? 0);
    if ($id && product_delete($id)) {
      flash('ok', 'Product deleted');
    } else {
      flash('err', 'DB error deleting product');
    }
    header('Location: ' . url('admin.php'));
    exit;
  }
}

// refresh list after modifications
$items = products_all();

// Admin reports data
$daily_sales  = report_daily_sales(14);   // last 14 days
$top_products = report_top_products(5);   // top 5
$low_stock    = report_low_stock(10);     // 10 lowest stock items


?>

<style>
  /* --- Admin: User Management Styles --- */

  .admin-wrapper {
    max-width: 1100px;
    margin: 2rem auto;
    padding: 0 1rem 3rem;
  }

  .admin-section-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 1rem;
    flex-wrap: wrap;
    margin-bottom: 1rem;
  }

  .admin-section-header h2 {
    margin: 0;
  }

  .admin-section-sub {
    margin: 0;
    font-size: .9rem;
    color: #666;
  }

  .user-table-card {
    background: #fff;
    border-radius: 0.8rem;
    box-shadow: 0 6px 20px rgba(0, 0, 0, .06);
    padding: 1.3rem 1.4rem;
  }

  .user-table-card h3 {
    margin-top: 0;
    margin-bottom: .85rem;
    font-size: 1.05rem;
  }

  /* Table */
  .user-table {
    width: 100%;
    border-collapse: collapse;
    font-size: .9rem;
  }

  .user-table thead tr {
    border-bottom: 2px solid #eee;
  }

  .user-table th,
  .user-table td {
    padding: .5rem .35rem;
  }

  .user-table th {
    text-align: left;
    font-size: .75rem;
    text-transform: uppercase;
    letter-spacing: .06em;
    color: #777;
  }

  .user-table tbody tr:nth-child(even) {
    background: #fafafa;
  }

  .user-table tbody tr:hover {
    background: #f3f3f3;
  }

  /* Role badges */
  .role-badge {
    display: inline-block;
    padding: .15rem .55rem;
    border-radius: 999px;
    font-size: .75rem;
    text-transform: capitalize;
  }

  .role-badge.customer {
    background: #e6f0ff;
    color: #1d4ed8;
  }

  .role-badge.staff {
    background: #fff7e6;
    color: #b45309;
  }

  .role-badge.manager {
    background: #e6f7f0;
    color: #047857;
  }

  .role-badge.admin {
    background: #fee2e2;
    color: #b91c1c;
  }

  /* Tiny stats row */
  .user-meta {
    font-size: .75rem;
    color: #777;
  }

  /* Inline form */
  .user-action-form {
    display: inline-flex;
    align-items: center;
    gap: .35rem;
  }

  .user-action-form select {
    font-size: .8rem;
    padding: .15rem .35rem;
  }

  .user-action-form .btn {
    padding: .2rem .7rem;
    font-size: .8rem;
  }

  .badge-count {
    display: inline-block;
    font-size: .75rem;
    padding: .1rem .45rem;
    border-radius: 999px;
    background: #f3f4f6;
    color: #4b5563;
  }

  /* --- Admin: Reports --- */
  .admin-reports {
    max-width: 1000px;
    margin: 2rem auto;
    padding: 0 1rem 2.5rem;
  }

  .admin-reports h1 {
    margin-top: 0;
    margin-bottom: 1rem;
  }

  .report-grid {
    display: grid;
    gap: 1.5rem;
  }

  @media (min-width: 900px) {
    .report-grid {
      grid-template-columns: minmax(0, 1.7fr) minmax(0, 1.3fr);
    }
  }

  .report-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 6px 18px rgba(0, 0, 0, .06);
    padding: 1rem 1.2rem;
  }

  .report-card h2 {
    margin-top: 0;
    margin-bottom: .7rem;
    font-size: 1.05rem;
  }

  /* Tables */
  .report-table {
    width: 100%;
    border-collapse: collapse;
    font-size: .9rem;
  }

  .report-table thead tr {
    border-bottom: 2px solid #eee;
  }

  .report-table th,
  .report-table td {
    padding: .45rem .3rem;
  }

  .report-table th {
    text-align: left;
    font-size: .75rem;
    text-transform: uppercase;
    letter-spacing: .06em;
    color: #777;
  }

  .report-table tbody tr:nth-child(even) {
    background: #fafafa;
  }

  .report-table tbody tr:hover {
    background: #f3f3f3;
  }

  /* Number formatting */
  .text-right {
    text-align: right;
  }

  .badge-soft {
    display: inline-block;
    padding: .1rem .45rem;
    border-radius: 999px;
    font-size: .75rem;
    background: #f3f4f6;
    color: #4b5563;
  }

  .badge-soft-danger {
    background: #fee2e2;
    color: #b91c1c;
  }
</style>

<h1>Admin: Products</h1>

<h2>Add product</h2>
<form method="post" class="grid" style="grid-template-columns:1fr 1fr">
  <input type="hidden" name="act" value="create">
  <div class="field"><label>Name</label><input name="name"></div>
  <div class="field"><label>Price</label><input name="price" type="number" step="0.01"></div>
  <div class="field">
    <label>Category</label>
    <select name="category_id">
      <option value="">-- Select category --</option>
      <?php foreach ($cats as $c): ?>
        <option value="<?= (int)$c['id'] ?>"><?= e($c['name']) ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="field"><label>Stock Quantity</label><input name="stock_qty" type="number" step="1"></div>
  <div class="field" style="grid-column:1/-1"><label>Image URL</label><input name="img"></div>
  <div class="field" style="grid-column:1/-1"><label>Description</label><textarea name="desc" rows="3"></textarea></div>
  <div><button class="btn">Add</button></div>
</form>

<!-- ///////////////This section is for the admin report dasboard//////////// -->
<div class="admin-reports">
  <h1>Sales & Inventory Reports</h1>

  <div class="report-grid">
    <!-- Sales over time -->
    <div class="report-card">
      <h2>Sales (last 14 days)</h2>
      <?php if (!$daily_sales): ?>
        <p style="font-size:.9rem;color:#555;">No sales data yet.</p>
      <?php else: ?>
        <table class="report-table">
          <thead>
            <tr>
              <th>Date</th>
              <th class="text-right">Orders</th>
              <th class="text-right">Revenue</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($daily_sales as $row): ?>
              <tr>
                <td><?= e($row['day']) ?></td>
                <td class="text-right"><?= (int)$row['orders'] ?></td>
                <td class="text-right">
                  R<?= number_format((float)$row['revenue'], 2) ?>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php endif; ?>
    </div>

    <!-- Top products -->
    <div class="report-card">
      <h2>Top Products</h2>
      <?php if (!$top_products): ?>
        <p style="font-size:.9rem;color:#555;">No product sales yet.</p>
      <?php else: ?>
        <table class="report-table">
          <thead>
            <tr>
              <th>Product</th>
              <th class="text-right">Qty sold</th>
              <th class="text-right">Revenue</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($top_products as $p): ?>
              <tr>
                <td>
                  <?= e($p['name']) ?><br>
                  <span class="badge-soft">ID #<?= (int)$p['product_id'] ?></span>
                </td>
                <td class="text-right"><?= (int)$p['qty_sold'] ?></td>
                <td class="text-right">
                  R<?= number_format((float)$p['revenue'], 2) ?>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php endif; ?>
    </div>
  </div>

  <!-- Low stock alerts -->
  <div class="report-card" style="margin-top:1.5rem;">
    <h2>Low Stock Alerts</h2>
    <?php if (!$low_stock): ?>
      <p style="font-size:.9rem;color:#555;">No low stock items right now.</p>
    <?php else: ?>
      <table class="report-table">
        <thead>
          <tr>
            <th>Product</th>
            <th>SKU</th>
            <th class="text-right">Stock</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($low_stock as $p): ?>
            <tr>
              <td>
                <?= e($p['name']) ?><br>
                <span class="badge-soft">ID #<?= (int)$p['id'] ?></span>
              </td>
              <td><?= e($p['sku'] ?? '') ?></td>
              <td class="text-right">
                <span class="badge-soft badge-soft-danger">
                  <?= (int)$p['stock_qty'] ?>
                </span>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
  </div>
</div>

<hr>
<h2>Recent Orders</h2>
<?php
global $mysqli, $USE_DB;
if ($USE_DB && $mysqli):

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
      <?php while ($row = mysqli_fetch_assoc($res)): ?>
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
  <?php endif;
else: ?>
  <p class="error">DB not active.</p>
<?php endif; ?>


<h2>Existing</h2>
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse;width:100%">
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Price</th>
    <th>Stock Quantity</th>
    <th>Preview</th>
    <th></th>
  </tr>
  <?php foreach ($items as $p): ?>
    <tr>
      <td><?= (int)$p['id'] ?></td>
      <td><?= e($p['name']) ?></td>
      <td>R<?= number_format($p['price'], 2) ?></td>
      <td><?= ($p['stock_qty']) ?></td>
      <td><img src="<?= e($p['img']) ?>" style="height:40px"></td>
      <td>
        <form method="post" style="display:inline">
          <input type="hidden" name="act" value="delete">
          <button class="btn" name="id" value="<?= (int)$p['id'] ?>">Delete</button>
        </form>
        <a class="btn" href="<?= url('product.php?id=' . (int)$p['id']) ?>">View</a>
        <a class="btn btn-sm btn-warning" href="admin-product-edit.php?id=<?= (int)$p['id'] ?>">Update</a>
      </td>
    </tr>
  <?php endforeach; ?>
</table>

<hr>
<!-- ///////////////////////ADMIN ROLL MANGEMENT//////////// -->
<div class="admin-wrapper" id="users">
  <div class="admin-section-header">
    <div>
      <h2>User Management</h2>
      <p class="admin-section-sub">
        View all registered users and manage their roles. Only <strong>admins</strong> can change roles.
      </p>
    </div>
    <div>
      <span class="badge-count">
        Total users: <?= count($users ?? []) ?>
      </span>
    </div>
  </div>

  <div class="user-table-card">
    <h3>All users</h3>

    <?php if (!$users): ?>
      <p>No users found.</p>
    <?php else: ?>
      <table class="user-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>User</th>
            <th>Role</th>
            <th>Member since</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($users as $u): ?>
            <?php
            $uid   = (int)$u['id'];
            $role  = strtolower($u['role'] ?? 'customer');
            $since = $u['created_at'] ?? null;
            ?>
            <tr>
              <td>#<?= $uid ?></td>

              <td>
                <div><strong><?= e($u['name'] ?? '') ?></strong></div>
                <div class="user-meta"><?= e($u['email'] ?? '') ?></div>
              </td>

              <td>
                <span class="role-badge <?= $role ?>">
                  <?= ucfirst($role) ?>
                </span>
              </td>

              <td>
                <?php if ($since): ?>
                  <span class="user-meta"><?= e($since) ?></span>
                <?php else: ?>
                  <span class="user-meta">&mdash;</span>
                <?php endif; ?>
              </td>

              <td>
                <?php if (is_admin() && $current && $current['id'] !== $uid): ?>
                  <form method="post" class="user-action-form">
                    <input type="hidden" name="action" value="update_user_role">
                    <input type="hidden" name="user_id" value="<?= $uid ?>">

                    <select name="role">
                      <?php foreach (user_roles_all() as $r): ?>
                        <option value="<?= $r ?>"
                          <?= ($r === $role) ? 'selected' : '' ?>>
                          <?= ucfirst($r) ?>
                        </option>
                      <?php endforeach; ?>
                    </select>

                    <button type="submit" class="btn">Save</button>
                  </form>
                <?php else: ?>
                  <span class="user-meta">No actions</span>
                <?php endif; ?>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
  </div>
</div>
<?php require __DIR__ . '/footer.php'; ?>