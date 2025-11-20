<?php require __DIR__.'/config.php'; 

// Compute current user + EcoPoints balance once for the header
$u = auth_user();
$ecopoints_balance = $u ? ecopoints_balance($u['id']) : null;
?>
<!DOCTYPE html><html lang="en"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= e($title ?? 'DragonStone') ?></title>
<style>
  :root{--brand:#0ea5e9;--ink:#0b1a2b;--muted:#f6f8fb;--border:#e5e7eb;}
  body{margin:0;font-family:system-ui,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink)}
  header,footer{background:var(--muted);padding:.9rem 1rem}
  .container{max-width:1000px;margin:0 auto;padding:0 1rem}
  nav a{margin-right:1rem;color:#fff;text-decoration:none}
  .pill{display:inline-block;border:1px solid var(--border);border-radius:999px;padding:.05rem .4rem;font-size:.8rem}
  .grid{display:grid;gap:1rem}
  .cards{grid-template-columns:repeat(auto-fit,minmax(220px,1fr))}
  .card{border:1px solid var(--border);border-radius:12px;overflow:hidden;background:#fff}
  .pad{padding:.75rem}
  .btn{display:inline-block;background:#111;color:#fff;border-radius:8px;padding:.45rem .7rem;text-decoration:none}
  .btn.ghost{background:#fff;color:#111;border:1px solid var(--border)}
  .row{display:flex;gap:.5rem;align-items:center;flex-wrap:wrap;justify-content:space-between}

  header a:hover {
  color: var(--ink); /* Change link color on hover for better contrast */
}

/* Base styles for the animated underline */
header nav a,
.brand-link {
  position: relative; /* Position the pseudo-element relative to the link */
  text-decoration: none; /* Remove the default underline */
}

header nav a::after,
.brand-link::after {
  content: ''; /* Required for pseudo-elements */
  position: absolute;
  width: 100%;
  transform: scaleX(0); /* Hide the line by default */
  height: 5px;
  bottom: -5px; /* Adjust spacing from the text */
  left: 0;
  background-color: #bcf0b6ff; /* Brand blue color */
  transform-origin: bottom right; /* Animate from right to left */
  transition: transform 0.30s ease-out; /* Add a smooth animation */
}

/* Hover state: show and animate the line */
header nav a:hover::after,
.brand-link:hover::after {
  transform: scaleX(1); /* Expand the line to full width */
  transform-origin: bottom left; /* Animate from left to right on hover */
}
  input,textarea{padding:.5rem;border:1px solid var(--border);border-radius:8px;width:100%}
  .field{margin:.5rem 0}
  .error{color:#b91c1c}.ok{color:#059669}

   body {
    background-image: url('https://t4.ftcdn.net/jpg/05/67/48/63/360_F_567486394_PxcgLM8vtZqyH71fpkcpeKLDZfsbTyHO.jpg');
    background-size: cover;
    background-attachment: fixed;
    background-position: center;
    background-repeat: no-repeat;
    background-color: #f0f0f0;
  }

  /* styling the eco points badge */
.badge{
  display:inline-block;
  padding:0.1rem .5rem;
  border-radius:999px;
  font-size:.8rem;
  background:#111;
  color:#fff;
  margin-left:.5rem;
}
</style>


</head><body>

    <!-- Google tag (gtag.js) -->
<!-- <script async src="https://www.googletagmanager.com/gtag/js?id=G-MCF1TFSXFN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-MCF1TFSXFN');
</script> -->
<header  class="site-header" style="background-color: #7cca74ff; color: white;">
  
  <div class="container row">
    <div>
      <a class="btn ghost" href="<?= url('index.php')?>"><b>DragonStone</b></a>
      <nav style="display:inline">
        <a href="<?= url('products.php')?>">Products</a>
        <a href="<?= url('cart.php')?>">Cart <span class="pill"><?= array_sum(cart_get() ?: []) ?></span></a>
        <?php if(is_admin()): ?><a href="<?= url('admin.php')?>">Admin</a><?php endif; ?>
		<?php if (auth_user()): ?><a href="<?= url('orders.php') ?>">My Orders</a><?php endif; ?>
      <?php if ($u): ?><a href="<?= url('ecopoints.php') ?>">My EcoPoints</a><?php endif; ?>
        <!-- <a href="<?= url('docs.php')?>">Docs</a> -->
         <a href="<?= url('community.php')?>">Community</a>

         <!-- display ecopoints in the header -->
    <?php if(!empty($ecopoints_balance)): ?>
  <span class="badge">EcoPoints: <?= (int)$ecopoints_balance ?></span>
<?php endif; ?>
      </nav>
    </div>
    <div>
      <?php if($u = auth_user()): ?>
        Hello, <?= e($u['name']) ?> • <a href="<?= url('logout.php')?>">Logout</a>
      <?php else: ?>
        <a href="<?= url('login.php')?>">Login</a> / <a href="<?= url('register.php')?>">Register</a>
      <?php endif; ?>
    </div>
  </div>
  <?php if($m=flash('ok')): ?><div class="container ok"><?= e($m) ?></div><?php endif; ?>
  <?php if($m=flash('err')): ?><div class="container error"><?= e($m) ?></div><?php endif; ?>

    
</header>
<main class="container" style="padding:1rem 0">
