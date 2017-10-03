<?php
  require_once 'Parsedown.php';
  $parsedown = new Parsedown();
  $text = file_get_contents('README.md');
  echo "<title>Project laboratory</title>";
  echo "<a href='http://172.25.0.254/pub' target='_blank'>Visit Local Resources!</a>";
  echo $parsedown->text($text);
?>
