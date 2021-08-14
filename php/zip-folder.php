<?php

/**
 * Zip folder by providing request parameter
 * 
 * @param $_REQUEST['folder_name'] { "folder_name_to_zip" }
 */

$path_of_folder = "svn";

if( ! isset($_REQUEST['folder_name']) ){
    return;
} 

$path_of_folder = $_REQUEST['folder_name'];

$name_of_outout_file = "demo.zip";

$rootPath = realpath($path_of_folder);

// Initialize archive object
$zip = new ZipArchive();
$zip->open('file.zip', ZipArchive::CREATE | ZipArchive::OVERWRITE);

// Create recursive directory iterator
/** @var SplFileInfo[] $files */
$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($rootPath),
    RecursiveIteratorIterator::LEAVES_ONLY
);

foreach ($files as $name => $file)
{
    // Skip directories (they would be added automatically)
    if (!$file->isDir())
    {
        // Get real and relative path for current file
        $filePath = $file->getRealPath();
        $relativePath = substr($filePath, strlen($rootPath) + 1);

        // Add current file to archive
        $zip->addFile($filePath, $relativePath);
    }
}

// Zip archive will be created only after closing object
$zip->close();