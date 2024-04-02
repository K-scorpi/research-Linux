<?php
ob_start();

echo 'web shell ok';


file_put_contents('/home/os/p.log',ob_get_contents());
ob_end_flush();
?>
