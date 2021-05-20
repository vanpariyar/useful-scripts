<?php
	echo '<pre>';
	echo '<span style="color:blue">DOWNLOADING...</span>'.PHP_EOL;

	// Download file
	file_put_contents('wp.zip', file_get_contents('https://wordpress.org/latest.zip'));
	
	$zip = new ZipArchive();
	$res = $zip->open('wp.zip');
	if ($res === TRUE) {
		
		// Extract ZIP file
		$zip->extractTo('./');
		$zip->close();
		unlink('wp.zip');
		
		// Copy files from wordpress dir to current dir
		$files = find_all_files("wordpress");
		$source = "wordpress/";
		foreach ($files as $file) {
			$file = substr($file, strlen("wordpress/"));
			if (in_array($file, array(".",".."))) continue;
			if (!is_dir($source.$file)){
				echo '[FILE] '.$source.$file .' -> '.$file . PHP_EOL;
				rename($source.$file, $file);
			}else{
				echo '[DIR]  '.$file . PHP_EOL;
				@mkdir($file);
			}
		}
		
		// Remove wordpress dir
		foreach ($files as $file) {
			if (in_array($file, array(".",".."))) continue;
			if (is_dir($file)){
				echo '[REM]  '.$file . PHP_EOL;
				@rmdir($file);
			}
		}
		@rmdir('./wordpress');
		
		// Check if copy was successful
		if(file_exists('index.php')){
		
			// Redirect to WP installation page
			echo '<meta http-equiv="refresh" content="1;url=index.php" />';
		
		}else{
			echo 'Oops, that didn\'t work...';
		}
	} else {
		echo 'Oops, that didn\'t work...';
	}
	
	function find_all_files($dir) { 
    $root = scandir($dir); 
    foreach($root as $value) { 
        if($value === '.' || $value === '..') {continue;} 
        $result[]="$dir/$value";
        if(is_file("$dir/$value")) {continue;} 
        foreach(find_all_files("$dir/$value") as $value) 
        { 
            $result[]=$value; 
        } 
    } 
    return $result; 
} 
?>