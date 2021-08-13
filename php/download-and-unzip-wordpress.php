<?php

echo '<pre>';
echo '<span style="color:blue">DOWNLOADING...</span>'.PHP_EOL;

// Download file
file_put_contents('wp.zip', file_get_contents('https://wordpress.org/latest.zip'));

$zip = new ZipArchive();
$res = $zip->open('wp.zip');

if ($res === TRUE) {
    $zip->extractTo('.'); // directory to extract contents to
    $zip->close();
    echo ' wordpress.zip extracted; ';
    unlink('wp.zip');
    echo ' wordpress.zip deleted; ';
} else {
    echo ' unzip failed; ';
}

?>