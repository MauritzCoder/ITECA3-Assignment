<?php require __DIR__.'/config.php'; 
$_SESSION['user']=null; 
flash('ok','Signed out'); 
header('Location: '.url('index.php')); ?>
