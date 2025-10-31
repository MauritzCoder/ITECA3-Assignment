<?php $title='Products'; require __DIR__.'/header.php'; $items=products_all(); ?>
<h1>Products</h1>
<section class="grid cards">
<?php foreach($items as $p): ?>
  <article class="card" style="background-color: #bcf0b6ff;">

    <img src="<?=e($p['img'])?>" alt="<?= e($p['name'])?>" style="width:100%;height:180px;object-fit:cover">
    <div class="pad">
      <h3 style="margin:.2rem 0"><?= e($p['name'])?></h3>
      <div class="row"><span>R<?= number_format($p['price'],2) ?></span>
        <span><a class="btn" href="<?= url('product.php?id='.(int)$p['id'])?>">View</a></span>
      </div>
    </div>
  </article>
<?php endforeach; ?>
</section>
<?php require __DIR__.'/footer.php'; ?>
