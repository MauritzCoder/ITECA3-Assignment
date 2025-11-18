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

<style>
/* --- EcoPoints hints on community page --- */
.ep-info-banner {
  margin: 0 0 1.5rem;
  padding: .75rem 1rem;
  border-radius: .6rem;
  background: #e6f4ea;
  border: 1px solid #c6e3cf;
  font-size: .9rem;
  color: #205233;
}

.ep-info-banner strong {
  font-weight: 600;
}

.ep-pill {
  display: inline-block;
  padding: .1rem .55rem;
  border-radius: 999px;
  background: #205233;
  color: #fff;
  font-size: .75rem;
  margin-left: .35rem;
}

.ep-hint {
  font-size: .8rem;
  color: #555;
  margin-top: .3rem;
}
</style>

<div class="ep-info-banner">
  <strong>Earn EcoPoints in the Community!</strong><br>
  Start a new topic and share your eco-friendly tips or DIY projects:
  <span class="ep-pill">+<?= ECOPOINTS_POST ?> pts per post</span>,
  <span class="ep-pill">+<?= ECOPOINTS_COMMENT ?> pts per comment</span>
</div>

<p class="muted">Share eco tips, DIY projects, and sustainability challenges. Earn EcoPoints for contributions.</p>

<?php if($user): ?>
  <section class="card" style="margin-bottom:2rem;">
  <h2>Create a new post</h2>
  <p class="ep-hint">
    Share your eco tips, DIY projects or sustainability challenges and earn
    <strong><?= ECOPOINTS_POST ?> EcoPoints</strong> when your post is published.
  </p>

  <form method="post">
    <div class="field">
      <label for="title">Title</label>
      <input type="text" name="title" id="title" required>
    </div>

    <div class="field">
      <label for="body">Post content</label>
      <textarea name="body" id="body" rows="6" required></textarea>
    </div>

    <div class="field">
      <label for="tags">Tags (optional)</label>
      <input type="text" name="tags" id="tags" placeholder="e.g. cleaning, DIY, zero-waste">
    </div>

    <button type="submit" class="btn">
      Publish post
      <span class="ep-pill">+<?= ECOPOINTS_POST ?> pts</span>
    </button>
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