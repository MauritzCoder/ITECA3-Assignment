<?php
declare(strict_types=1);
$title = 'My EcoPoints';
require __DIR__.'/header.php';

$u = auth_user();
if (!$u) {
  flash('err', 'Please log in to view your EcoPoints.');
  header('Location: '.url('login.php'));
  exit;
}

$balance = ecopoints_balance($u['id']);
$rows    = ecopoints_history($u['id']);
?>

<style>
/* --- EcoPoints page specific styling --- */
.ecopoints-page {
  max-width: 960px;
  margin: 2rem auto;
  padding: 0 1rem;
}

.ecopoints-header {
  display: flex;
  justify-content: space-between;
  align-items: stretch;
  gap: 1.5rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.ecopoints-title-block h1 {
  margin: 0 0 .4rem;
}

.ecopoints-title-block p {
  margin: 0;
  font-size: .9rem;
  color: #555;
}

.ep-balance-card {
  min-width: 220px;
  padding: 1rem 1.2rem;
  border-radius: .8rem;
  background: #0f5132;
  color: #fff;
  box-shadow: 0 6px 20px rgba(0,0,0,.12);
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.ep-balance-label {
  font-size: .8rem;
  text-transform: uppercase;
  letter-spacing: .08em;
  opacity: .9;
  margin-bottom: .2rem;
}

.ep-balance-value {
  font-size: 1.8rem;
  font-weight: 600;
  line-height: 1.2;
}

.ep-balance-caption {
  font-size: .8rem;
  margin-top: .4rem;
  opacity: .9;
}

/* Table card */
.ep-table-card {
  padding: 1.2rem 1.4rem;
  border-radius: .8rem;
  background: #fff;
  box-shadow: 0 4px 14px rgba(0,0,0,.06);
}

.ep-table-card h2 {
  margin-top: 0;
  margin-bottom: .75rem;
  font-size: 1.1rem;
}

/* Table styling */
.ep-table {
  width: 100%;
  border-collapse: collapse;
  font-size: .9rem;
}

.ep-table thead tr {
  border-bottom: 2px solid #eee;
}

.ep-table th,
.ep-table td {
  padding: .5rem .3rem;
}

.ep-table th {
  text-align: left;
  font-size: .8rem;
  text-transform: uppercase;
  letter-spacing: .06em;
  color: #777;
}

.ep-table tbody tr:nth-child(even) {
  background: #fafafa;
}

.ep-table tbody tr:hover {
  background: #f3f3f3;
}

/* Delta pill */
.ep-delta {
  display: inline-block;
  min-width: 3.5rem;
  text-align: right;
  font-feature-settings: "tnum" 1;
}

.ep-delta.positive {
  color: #1f7a3e;
  font-weight: 600;
}

.ep-delta.negative {
  color: #b02a37;
  font-weight: 600;
}

/* Empty state */
.ep-empty {
  padding: 1rem 1.2rem;
  border-radius: .6rem;
  background: #f5f5f5;
  font-size: .9rem;
}

.ep-empty strong {
  font-weight: 600;
}
</style>

<section class="ecopoints-page">
  <div class="ecopoints-header">
    <div class="ecopoints-title-block">
      <h1>My EcoPoints</h1>
      <p>Track how you earn rewards for sustainable shopping and community contributions on DragonStone.</p>
    </div>

    <div class="ep-balance-card">
      <div class="ep-balance-label">Current balance</div>
      <div class="ep-balance-value"><?= (int)$balance ?> pts</div>
      <div class="ep-balance-caption">
        Earn points for purchases and community activity. Redeem them later for rewards or donations.
      </div>
    </div>
  </div>

  <?php if (!$rows): ?>
    <div class="ep-empty">
      <strong>No EcoPoints activity yet.</strong><br>
      Place an order or join the Community to start earning points.
    </div>
  <?php else: ?>
    <div class="ep-table-card">
      <h2>Activity history</h2>
      <table class="ep-table">
        <thead>
          <tr>
            <th>Date</th>
            <th style="text-align:right;">Points</th>
            <th>Reason</th>
            <th>Reference</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($rows as $row): ?>
            <?php
              $delta    = (int)$row['delta'];
              $isPos    = $delta > 0;
              $deltaTxt = ($isPos ? '+' : '') . $delta;
            ?>
            <tr>
              <td><?= e($row['created_at']) ?></td>
              <td style="text-align:right;">
                <span class="ep-delta <?= $isPos ? 'positive' : 'negative' ?>">
                  <?= $deltaTxt ?>
                </span>
              </td>
              <td><?= e(ucfirst($row['reason'])) ?></td>
              <td>
                <?php if ($row['ref_type'] === 'order' && $row['ref_id']): ?>
                  Order #<?= (int)$row['ref_id'] ?>
                <?php elseif ($row['ref_type'] === 'forum_post' && $row['ref_id']): ?>
                  Forum post #<?= (int)$row['ref_id'] ?>
                <?php elseif ($row['ref_type'] === 'forum_comment' && $row['ref_id']): ?>
                  Forum comment #<?= (int)$row['ref_id'] ?>
                <?php else: ?>
                  &mdash;
                <?php endif; ?>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  <?php endif; ?>
</section>

<?php require __DIR__.'/footer.php'; ?>