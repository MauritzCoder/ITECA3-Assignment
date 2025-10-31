<?php
$title = 'Community Post';
require __DIR__.'/header.php';
//require __DIR__.'/functions.php';




$user = $_SESSION['user'] ?? null;
$key = $_GET['post'] ?? null;
if(!$key){ echo "<p>Post not found.</p>"; require __DIR__.'/footer.php'; exit; }

$post = forum_post_get($key);
if(!$post){ echo "<p>Post not found.</p>"; require __DIR__.'/footer.php'; exit; }

// handle upvote
if($_SERVER['REQUEST_METHOD']==='POST' && isset($_POST['action']) && $_POST['action']==='upvote'){
  require_user();
  forum_upvote((int)$post['id'], (int)$user['id']);
  // reload
  $post = forum_post_get($key);
}

// handle comment
if($_SERVER['REQUEST_METHOD']==='POST' && isset($_POST['action']) && $_POST['action']==='comment'){
  require_user();
  $body = trim($_POST['body'] ?? '');
  if($body!==''){
    forum_comment_create((int)$post['id'], (int)$user['id'], $body);
  }
}

// fetch comments
$comments = forum_comments_for((int)$post['id']);
?>
<article class="card pad">
  <h1 style="margin:.2rem 0"><?= e($post['title']) ?></h1>
  <p class="muted">by <?= e($post['author'] ?? 'Anonymous') ?> · <?= e(date('Y-m-d H:i', strtotime($post['created_at']))) ?> · 👍 <?= (int)$post['upvotes'] ?> · 💬 <?= (int)$post['comments_cnt'] ?></p>
  <?php if(!empty($post['tags'])): ?><p class="muted">Tags: #<?= e($post['tags']) ?></p><?php endif; ?>
  <div style="white-space:pre-wrap; line-height:1.4"><?= nl2br(e($post['body'])) ?></div>

  <form method="post" class="row" style="margin-top:1rem; gap:.5rem">
    <input type="hidden" name="action" value="upvote">
    <?php if($user): ?>
      <button class="btn" type="submit">👍 Upvote</button>
      <span class="muted">Thanks for supporting eco ideas!</span>
    <?php else: ?>
      <a class="btn" href="login.php">Log in to upvote</a>
    <?php endif; ?>
  </form>
</article>

<section class="card pad" style="margin-top:1rem">
  <h3>Comments (<?= count($comments) ?>)</h3>

  <?php if($user): ?>
  <form method="post" style="margin:.6rem 0">
    <input type="hidden" name="action" value="comment">
    <textarea name="body" rows="4" placeholder="Add your comment…" required style="width:100%;"></textarea>
    <div class="row" style="justify-content:space-between;margin-top:.4rem">
      <small class="muted">Earn +<?= ECOPOINTS_COMMENT ?> EcoPoints</small>
      <button class="btn">Post Comment</button>
    </div>
  </form>
  <?php else: ?>
    <div class="alert">Please <a href="login.php">log in</a> to comment & earn EcoPoints.</div>
  <?php endif; ?>

  <?php foreach($comments as $c): ?>
    <div class="card" style="margin:.5rem 0">
      <div class="pad">
        <p style="margin:0 0 .2rem 0"><strong><?= e($c['author'] ?? 'Anonymous') ?></strong> · <span class="muted"><?= e(date('Y-m-d H:i',strtotime($c['created_at']))) ?></span></p>
        <div style="white-space:pre-wrap"><?= nl2br(e($c['body'])) ?></div>
      </div>
    </div>
  <?php endforeach; ?>
</section>

<?php require __DIR__.'/footer.php'; ?>