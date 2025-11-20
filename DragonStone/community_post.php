<?php
declare(strict_types=1);
$title = 'Community Post';

// 0) Start session BEFORE any output
if (session_status() !== PHP_SESSION_ACTIVE) {
  session_start();
}

require __DIR__.'/header.php'; // ok if header also starts session

// 1) Robust current user extraction (flat OR nested)
$user_id = null;
if (isset($_SESSION['user_id'])) {
  $user_id = (int)$_SESSION['user_id'];
}
$userArr = $_SESSION['user'] ?? $_SESSION['auth'] ?? null;
if ($user_id === null && is_array($userArr)) {
  foreach (['id','user_id','userid','ID','uid'] as $k) {
    if (isset($userArr[$k])) { $user_id = (int)$userArr[$k]; break; }
  }
}
$user = $userArr ?: null; // used by your template checks (if($user))

// 2) Identify the post (support ?post=slug OR ?id=number)
$opened_with_post = array_key_exists('post', $_GET);
$key = $_GET['post'] ?? ($_GET['id'] ?? '');
if ($key === '') { echo "<p>Post not found.</p>"; require __DIR__.'/footer.php'; exit; }

// DO NOT cast $key; let your resolver decide slug vs id
$post = forum_post_get($key);
if (!$post) { echo "<p>Post not found.</p>"; require __DIR__.'/footer.php'; exit; }

// Numeric PK for DB writes
$post_pk = (int)($post['id'] ?? 0);

// 3) Handle actions (single POST handler)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $action  = $_POST['action'] ?? '';
  $post_id = (int)($_POST['post_id'] ?? $post_pk);

  if (!$user_id) {
    // If you prefer redirect instead of exit:
    // header('Location: login.php?next='.urlencode($_SERVER['REQUEST_URI'])); exit;
    http_response_code(401);
    exit('Please sign in to comment or vote.');
  }

  if ($action === 'upvote') {
    forum_upvote($post_id, $user_id);
  } elseif ($action === 'comment') {
    $body = trim($_POST['body'] ?? '');
    if ($body !== '') {
      forum_comment_create($post_id, $user_id, $body);
    }
  }
  // PRG: redirect back using the same identifier you used to open
  $back = $opened_with_post
    ? 'community_post.php?post='.rawurlencode($key)
    : 'community_post.php?id='.$post_pk;
  header('Location: '.$back);
  exit;
}

// 4) Fetch comments for display
$comments = forum_comments_for($post_pk);
?>
<article class="card pad">
  <h1 style="margin:.2rem 0"><?= e($post['title']) ?></h1>
  <p class="muted">
    by <?= e($post['author'] ?? 'Anonymous') ?> ·
    <?= e(date('Y-m-d H:i', strtotime($post['created_at']))) ?> ·
    👍 <?= (int)$post['upvotes'] ?> ·
    💬 <?= (int)$post['comments_cnt'] ?>
  </p>
  <?php if(!empty($post['tags'])): ?>
    <p class="muted">Tags: #<?= e($post['tags']) ?></p>
  <?php endif; ?>
  <div style="white-space:pre-wrap; line-height:1.4"><?= nl2br(e($post['body'])) ?></div>

  <form method="post" class="row" style="margin-top:1rem; gap:.5rem">
    <input type="hidden" name="action" value="upvote">
    <input type="hidden" name="post_id" value="<?= $post_pk ?>">
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
      <input type="hidden" name="post_id" value="<?= $post_pk ?>">
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
        <p style="margin:0 0 .2rem 0">
          <strong><?= e($c['author'] ?? 'Anonymous') ?></strong> ·
          <span class="muted"><?= e(date('Y-m-d H:i',strtotime($c['created_at']))) ?></span>
        </p>
        <div style="white-space:pre-wrap"><?= nl2br(e($c['body'])) ?></div>
      </div>
    </div>
  <?php endforeach; ?>
</section>

<?php require __DIR__.'/footer.php'; ?>