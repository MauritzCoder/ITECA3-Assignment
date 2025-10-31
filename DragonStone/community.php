<?php
$title = 'Community';
require __DIR__.'/header.php';
require_once __DIR__.'/functions.php';

$user = $_SESSION['user'] ?? null; // adjust if you store user differently

// handle create post (POST)
if($_SERVER['REQUEST_METHOD']==='POST' && isset($_POST['action']) && $_POST['action']==='create'){
  require_user();
  $t = trim($_POST['title'] ?? '');
  $b = trim($_POST['body'] ?? '');
  $tags = trim($_POST['tags'] ?? '');
  if($t !== '' && $b !== ''){
    $pid = forum_post_create($user['id'] ?? null, $t, $b, $tags);
    if($pid){
      // fetch slug & redirect to view
      $post = forum_post_get((int)$pid);
      header('Location: community_post.php?post='.$post['slug']);
      exit;
    }
  }
}

// list posts
$posts = forum_posts_all(20,0);
?>
<h1>Community Hub</h1>
<p class="muted">Share eco tips, DIY projects, and sustainability challenges. Earn EcoPoints for contributions.</p>

<?php if($user): ?>
  <section class="card pad" style="margin-bottom:1rem">
    <h3>Create a new post</h3>
    <form method="post">
      <input type="hidden" name="action" value="create">
      <div class="row">
        <input type="text" name="title" placeholder="Title" required style="width:100%;margin:.3rem 0">
      </div>
      <div class="row">
        <textarea name="body" placeholder="Write your tips, project steps, or challenge details..." rows="6" required style="width:100%;margin:.3rem 0"></textarea>
      </div>
      <div class="row">
        <input type="text" name="tags" placeholder="tags (comma separated)" style="width:100%;margin:.3rem 0">
      </div>
      <button class="btn">Publish & Earn +<?= ECOPOINTS_POST ?> EcoPoints</button>
    </form>
  </section>
<?php else: ?>
  <div class="alert">Please <a href="login.php">log in</a> to create posts and earn EcoPoints.</div>
<?php endif; ?>

<section class="grid cards">
<?php foreach($posts as $p): ?>
  <article class="card">
    <div class="pad">
      <h3 style="margin:.2rem 0">
        <a href="community_post.php?post=<?= e($p['slug']) ?>"><?= e($p['title']) ?></a>
      </h3>
      <p class="muted" style="margin:0 0 .4rem 0">
        by <?= e($p['author'] ?? 'Anonymous') ?> · <?= e(date('Y-m-d H:i', strtotime($p['created_at']))) ?>
        <?php if(!empty($p['tags'])): ?> · <small>#<?= e($p['tags']) ?></small><?php endif; ?>
      </p>
      <div class="row" style="justify-content:space-between">
        <span>👍 <?= (int)$p['upvotes'] ?> · 💬 <?= (int)$p['comments_cnt'] ?></span>
        <a class="btn" href="community_post.php?post=<?= e($p['slug']) ?>">Open</a>
      </div>
    </div>
  </article>
<?php endforeach; ?>
</section>

<?php require __DIR__.'/footer.php'; ?>