#!/bin/bash

# Configuration
BACKUP_FILE=$1
DOMAIN_NAME=$2
TARGET_DIR="./repo_upload"
TEMP_EXTRACT="./temp_hestia"

if [ -z "$BACKUP_FILE" ] || [ -z "$DOMAIN_NAME" ]; then
    echo "Usage: ./extract_wp.sh [backup.tar] [domain.com]"
    exit 1
fi

# Ensure zstd is installed
if ! command -v zstd &> /dev/null; then
    echo "❌ Error: 'zstd' is not installed. Install it with: sudo apt install zstd"
    exit 1
fi

# 1. Create clean environment
echo "--- Preparing directories ---"
rm -rf "$TARGET_DIR" "$TEMP_EXTRACT"
mkdir -p "$TARGET_DIR"
mkdir -p "$TEMP_EXTRACT"

# 2. Extract the main Hestia backup
echo "--- Extracting main Hestia backup ---"
tar -xf "$BACKUP_FILE" -C "$TEMP_EXTRACT"

# 3. Extract the Web Files (.tar.zst)
# Based on your path: ./web/domain.com/domain_data.tar.zst
WEB_ZST="$TEMP_EXTRACT/web/$DOMAIN_NAME/domain_data.tar.zst"

if [ -f "$WEB_ZST" ]; then
    echo "--- Extracting internal web data (ZST) ---"
    mkdir -p "$TEMP_EXTRACT/web_data"
    # tar supports zstd with the --zstd flag or automatically in newer versions
    tar --zstd -xf "$WEB_ZST" -C "$TEMP_EXTRACT/web_data"
    
    # Locate wp-content within public_html or similar
    WP_PATH=$(find "$TEMP_EXTRACT/web_data" -type d -name "wp-content" | head -n 1)
    if [ -n "$WP_PATH" ]; then
        cp -r "$WP_PATH" "$TARGET_DIR/"
        echo "✅ Success: wp-content moved to $TARGET_DIR"
    else
        echo "❌ Error: wp-content folder not found inside web data."
    fi
else
    echo "❌ Error: Could not find $WEB_ZST"
fi

# 4. Extract the Database (.sql.zst)
# Based on your path: ./db/db_name/db_name.mysql.sql.zst
echo "--- Locating and Decompressing Database (ZST) ---"
DB_ZST=$(find "$TEMP_EXTRACT/db" -type f -name "*.sql.zst" | head -n 1)

if [ -n "$DB_ZST" ]; then
    zstd -d "$DB_ZST" -o "$TARGET_DIR/database_backup.sql"
    echo "✅ Success: Database extracted to $TARGET_DIR/database_backup.sql"
else
    echo "❌ Error: No .sql.zst file found in the backup."
fi

# 5. Cleanup
echo "--- Cleaning up temporary files ---"
rm -rf "$TEMP_EXTRACT"

echo "------------------------------------------------"
echo "Done! Files are ready in: $TARGET_DIR"
