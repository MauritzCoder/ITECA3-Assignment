<?php $title = 'Docs';
require __DIR__ . '/header.php'; ?>
<h1>MiniStore Docs</h1>

<h2>Purpose</h2>
<p>MiniStore is a teaching app that mirrors Weeks 1–8:</p>
<ul>
  <li>HTML/CSS (W1–3) for layout & styling</li>
  <li>JavaScript (W4–5) kept minimal (this demo is PHP-only)</li>
  <li>PHP (W6) for forms & validation</li>
  <li>MySQL (W7–8) switchable via <code>$USE_DB</code> in <code>config.php</code></li>
</ul>

<h2>How data flows</h2>
<ol>
  <li><b>Products</b> come from <code>products.json</code> if present → else MySQL (if enabled) → else the <code>$SEED_PRODUCTS</code> array.</li>
  <li><b>Cart</b> uses PHP <code>$_SESSION</code> to store item quantities (W6 forms).</li>
  <li><b>Auth</b> is session-only (no DB), with two demo users in <code>login.php</code>.</li>
  <li><b>Admin</b> writes products to <code>products.json</code> (DB-free CRUD stepping stone).</li>
</ol>

<h2>Key files</h2>
<ul>
  <li><code>config.php</code> – paths, <code>$USE_DB</code>, loads core includes.</li>
  <li><code>db.php</code> – mysqli connect (W8).</li>
  <li><code>data.php</code> – seed products.</li>
  <li><code>functions.php</code> – helpers: <code>products_all()</code>, <code>product_find()</code>, cart and auth helpers.</li>
  <li><code>header.php</code>, <code>footer.php</code> – layout + footer DB indicator.</li>
  <li><code>products.php</code> – listing; <code>product.php</code> – detail + “Add to cart”.</li>
  <li><code>checkout.php</code> – form + server-side validation (W6).</li>
  <li><code>admin.php</code> – JSON CRUD (no DB).</li>
  <li><code>schema.sql</code>, <code>sample-data.sql</code> – database creation for later swap-in (W7–8).</li>
</ul>

<h2>Switching to MySQL (later)</h2>
<ol>
  <li>Import <code>schema.sql</code>, then <code>sample-data.sql</code> into MySQL.</li>
  <li>Set <code>$USE_DB = true</code> in <code>config.php</code>.</li>
  <li>Ensure the footer shows <b>MySQL (active)</b>.</li>
</ol>

<h2>Activities for students</h2>
<ul>
  <li>Add a new product via Admin, then verify it appears in Products and Product pages.</li>
  <li>Modify <code>checkout.php</code> validation to include phone and postal code.</li>
  <li>Turn on MySQL and query products (see <code>products_all()</code> in <code>functions.php</code>).</li>
</ul>
<?php require __DIR__ . '/footer.php'; ?>