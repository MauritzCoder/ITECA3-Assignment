<?php
// ------- Basic config -------
$BASE_PATH = '/DragonStone';          // adjust if folder name differs
$USE_DB    = true;                    // set true when you want MySQL
$DB = ['host'=>'localhost','user'=>'root','pass'=>'','name'=>'dragonstone'];

// Path helpers
function base_path($path=''){ global $BASE_PATH; 
  return rtrim($BASE_PATH,'/').($path ? '/'.ltrim($path,'/') : '');
}
function url($path=''){ return base_path($path); }

// Start session
if (session_status() === PHP_SESSION_NONE) session_start();

// Load support files
require __DIR__.'/db.php';
require __DIR__.'/data.php';
require __DIR__.'/functions.php';
