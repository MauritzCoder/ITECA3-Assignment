<?php
$mysqli = null; $DB_OK = false;
if (!isset($USE_DB)) $USE_DB = false;

if ($USE_DB) {
  mysqli_report(MYSQLI_REPORT_OFF);
  $mysqli = @mysqli_connect($DB['host'],$DB['user'],$DB['pass'],$DB['name']);
  $DB_OK  = !!$mysqli;
}
