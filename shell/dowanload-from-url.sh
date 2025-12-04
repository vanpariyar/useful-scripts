#!/bin/bash

# 1. Create a directory for the downloads so they don't clutter your current folder
DIR_NAME="folder_name"
mkdir -p "$DIR_NAME"
cd "$DIR_NAME"

echo "Starting download into folder: $DIR_NAME"

# 2. Loop through the list of URLs
# We use 'IFS=' and 'read -r' to handle lines with spaces correctly
while IFS= read -r url; do
    # Skip empty lines
    if [ ! -z "$url" ]; then
        echo "---------------------------------------------------"
        echo "Downloading: $url"
        
        # wget options:
        # -c : Continue getting a partially-downloaded file (resume support)
        # --user-agent : Simulates a browser (sometimes helps with specific servers)
        # "$url" : Quotes are CRITICAL here because the URLs have spaces
        wget -c --user-agent="Mozilla/5.0" "$url"
    fi
done << 'EOF'
http://example.com/file 1.mp3
http://example.com/file 2.mp3
EOF

echo "All downloads complete."
