<?php $title = 'Products';
require __DIR__ . '/header.php';
$items = products_all();
$cats   = categories_all();

$cat_id = isset($_GET['cat']) ? (int)$_GET['cat'] : 0;;

// Map categories by id for easy lookup
$catsById = [];
foreach ($cats as $c) {
  $catsById[$c['id']] = $c;
}

// Hard-coded images per category, image links are posted here for the background of the category
$catImages = [
  1 => 'https://media.istockphoto.com/id/1315338184/photo/basket-with-brushes-rags-natural-sponges-and-cleaning-products.jpg?s=612x612&w=0&k=20&c=jVmWKp6yxPkVHZMVGJcyybKjzKkEObqhyV6xAHPN5wg=',   // Cleaning & Household
  2 => 'https://media.istockphoto.com/id/2167253729/photo/kitchen-countertop-with-utensils-vegetables-and-spices-on-brick-wall-background-copy-space.jpg?s=612x612&w=0&k=20&c=kkfFLVibZ6AeKX5JYsiLr1rYzzMTyc0r2i2GIyKwd_c=',    // Kitchen & Dining
  3 => 'https://media.istockphoto.com/id/1251694108/photo/scandinavian-concept-of-living-room-interior-with-design-sofa-coffee-table-plant-in-pot.jpg?s=612x612&w=0&k=20&c=ITXyoZJVlM4NlRynI5Vip1_ddWGIRPy1TyJhFbxL6Hk=',      // Home Décor & Living
  4 => 'https://media.istockphoto.com/id/1136976095/photo/white-ceramic-tray-with-home-spa-supplies-in-home-bathroom-for-relaxing-rituals-candlelight.jpg?s=612x612&w=0&k=20&c=Mj1go6ysC24UNlQ3QOwO59U4URuv_7uaTskLhkKyfes=',          // Bathroom & Personal Care
  5 => 'https://media.istockphoto.com/id/1198401626/photo/while-active-kids-running-parents-resting-on-sofa-using-laptop.jpg?s=612x612&w=0&k=20&c=JsdQB3oiwS21xBIWLSd8JDiGIz9IVrMOr47JQNFI1pg=',         // Lifestyle & Wellness
  6 => 'https://media.istockphoto.com/id/1285465143/photo/handsome-young-boy-plays-soccer-with-happy-golden-retriever-dog-at-the-backyard-lawn-he-plays.jpg?s=612x612&w=0&k=20&c=Sk3fVbGteoJKLTI1RoBJKzKLSrg7kLgJDVPbW-VPQt0=',         // Kids & Pets
  7 => 'https://media.istockphoto.com/id/2112749005/photo/modern-contemporary-style-small-wooden-terrace-in-lush-garden-with-house-interior-background.jpg?s=612x612&w=0&k=20&c=rtiD90a0nA3UpHfGsL1GnVG19GjIZd8H762MTgGcJug=',    // Outdoor & Garden



];
?>



<?php if ($cat_id === 0): ?>
<!-- what this peach of code is doing is it is grouping the products under there repected categorys -->
  <!-- VIEW 1: Category grid -->
  <h1>Shop by Category</h1>
  <section class="grid cards">
    <?php foreach ($cats as $c): 
      $id   = (int)$c['id'];
      $img  = $catImages[$id] ?? 'img/Background.jpg'; // fallback image
    ?>
      <a href="<?= url('products.php?cat='.$id) ?>" class="card" style="text-decoration:none;color:inherit;">
        <img src="<?= e($img) ?>" alt="<?= e($c['name']) ?>" 
             style="width:100%;height:180px;object-fit:cover">
        <div class="pad">
          <h2 style="margin:.3rem 0;"><?= e($c['name']) ?></h2>
          <p style="font-size:.9rem;color:#555;">
            Explore our <?= e($c['name']) ?> range.
          </p>
        </div>
      </a>
    <?php endforeach; ?>
  </section>

<?php else: ?>

  <!-- VIEW 2: Products within one category -->
  <?php 
    $catName = $catsById[$cat_id]['name'] ?? 'Products';
    // Filter products in PHP by category_id
    $filtered = array_filter($items, function($p) use ($cat_id) {
      return (int)($p['category_id'] ?? 0) === $cat_id;
    });
  ?>

  <!-- <p><a href="<?= url('products.php') ?>">&larr; Back to all categories</a></p> -->
  <h1><?= e($catName) ?></h1>

  <?php if (!$filtered): ?>
    <p>No products found in this category yet.</p>
  <?php else: ?>
    <section class="grid cards">
      <?php foreach ($filtered as $p): ?>
        <article class="card" style="background-color:#fffff;">
          <img src="<?= e($p['img'])?>" 
               alt="<?= e($p['name'])?>" 
               style="width:100%;height:180px;object-fit:cover">
          <div class="pad">
            <h3 style="margin:.2rem 0"><?= e($p['name'])?></h3>
            <div class="row">
              <span>R<?= number_format($p['price'],2) ?></span>
              <span><a class="btn" href="<?= url('product.php?id='.(int)$p['id'])?>">View</a></span>
            </div>
          </div>
        </article>
      <?php endforeach; ?>
    </section>
  <?php endif; ?>

<?php endif; ?>

<?php require __DIR__.'/footer.php'; ?>




<!-- <h1>Products</h1>
<section class="grid cards">
  <?php foreach ($items as $p): ?>
    <article class="card" style="background-color: #ffffffff;">

      <img src="<?= e($p['img']) ?>" alt="<?= e($p['name']) ?>" style="width:100%;height:180px;object-fit:cover">
      <div class="pad">
        <h3 style="margin:.2rem 0"><?= e($p['name']) ?></h3>
        <div class="row"><span>R<?= number_format($p['price'], 2) ?></span>
          <span><a class="btn" href="<?= url('product.php?id=' . (int)$p['id']) ?>">View</a></span>
        </div>
      </div>
    </article>
  <?php endforeach; ?>
</section>
<?php require __DIR__ . '/footer.php'; ?> -->