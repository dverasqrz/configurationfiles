<?php
echo "<h1>PHP 8 no Nginx</h1>";
echo "<h3>Meu IP: "; echo $_SERVER['HTTP_HOST'];
echo "<br>Minha porta: "; echo $_SERVER['SERVER_PORT'];
echo "<br>Teu IP: "; echo $_SERVER['REMOTE_ADDR'];      
?>