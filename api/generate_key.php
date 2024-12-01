<?php
// Generate a 32-byte (256-bit) random key
$key = bin2hex(random_bytes(32));
echo "Generated Key: " . $key . "\n";
?> 