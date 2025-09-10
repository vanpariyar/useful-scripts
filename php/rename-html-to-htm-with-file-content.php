<?php
/**
 * Convert all .html → .htm (except index.html) and update links inside files
 * Two-step approach: 1) Rename files 2) Update content based on renamed files
 *
 * Usage: php convert-to-htm.php /path/to/static-site
 */

$rootDir = $argv[1] ?? __DIR__;
if (!is_dir($rootDir)) {
    exit("❌ Directory not found: $rootDir\n");
}

echo "🔄 Converting .html → .htm in $rootDir (skipping index.html)...\n";

// Step 1: Find and rename all .html files (except index.html)
try {
    $rii = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator($rootDir)
    );
} catch (Exception $e) {
    exit("❌ Error reading directory: " . $e->getMessage() . "\n");
}

$renamedFiles = []; // Array to track what was renamed
$totalFiles = 0;
$htmlFiles = 0;

echo "\n📝 Step 1: Scanning and renaming files...\n";
foreach ($rii as $file) {
    echo $file->getPathname();
    if ($file->isDir()) continue;
    
    $totalFiles++;
    $filePath = $file->getPathname();
    $filename = $file->getFilename();
    
    // Debug: Show all files being processed
    echo "Processing: $filename\n";
    
    // Check if it's an HTML file (but not already .htm)
    if (preg_match('/\.html$/i', $filename) && !preg_match('/\.htm$/i', $filename)) {
        $htmlFiles++;
        echo "Found HTML file: $filename\n";
        
        // Rename .html → .htm (but skip index.html)
        if (strtolower($filename) !== 'index.html') {
            echo "Attempting to rename: $filename\n";
            $newPath = preg_replace('/\.html$/i', '.htm', $filePath);
            if (rename($filePath, $newPath)) {
                echo "✅ Renamed: $filename → " . basename($newPath) . "\n";
                // Store the original filename (without extension) for content replacement
                $originalName = preg_replace('/\.html$/i', '', $filename);
                $renamedFiles[] = $originalName;
            } else {
                echo "❌ Failed to rename: $filePath\n";
            }
        } elseif (strtolower($filename) === 'index.html') {
            echo "Skipping index.html\n";
        }
    }
}

echo "\n📊 Scan Results:\n";
echo "Total files found: $totalFiles\n";
echo "HTML files found: $htmlFiles\n";
echo "Files renamed: " . count($renamedFiles) . "\n";

// Step 2: Update content in all files based on renamed files array
if (count($renamedFiles) > 0) {
    echo "\n🔗 Step 2: Updating links in content...\n";
    try {
        $rii2 = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($rootDir, RecursiveDirectoryIterator::SKIP_DOTS)
        );
    } catch (Exception $e) {
        exit("❌ Error reading directory for step 2: " . $e->getMessage() . "\n");
    }

    foreach ($rii2 as $file) {
        if ($file->isDir()) continue;
        $filePath = $file->getPathname();
        $filename = $file->getFilename();

        // Process all readable files
        if (is_readable($filePath)) {
            $content = file_get_contents($filePath);
            
            if ($content !== false) {
                $originalContent = $content;
                
                // Replace .html with .htm in all links to match the file extensions
                // This ensures URLs point to the .htm files consistently
                $content = preg_replace('/\.html\b/i', '.htm', $content);

                // Only write if content changed
                if ($content !== $originalContent) {
                    if (file_put_contents($filePath, $content) !== false) {
                        echo "Updated links inside: $filename\n";
                    } else {
                        echo "❌ Failed to update: $filePath\n";
                    }
                }
            } else {
                echo "❌ Failed to read: $filePath\n";
            }
        }
    }
} else {
    echo "\n⚠️ No files were renamed, skipping content update step.\n";
}

echo "\n📋 Summary:\n";
echo "Files renamed: " . count($renamedFiles) . "\n";
if (!empty($renamedFiles)) {
    echo "Renamed files: " . implode(', ', $renamedFiles) . "\n";
}
echo "✅ Conversion complete.\n";
