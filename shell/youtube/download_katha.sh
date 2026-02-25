#!/bin/bash

# ==========================================
# YouTube Playlist Downloader
# Automatically installs yt-dlp and ffmpeg if missing
# ==========================================

install_yt_dlp() {
    echo "Attempting to install yt-dlp..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install yt-dlp
        else
            sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
            sudo chmod a+rx /usr/local/bin/yt-dlp
        fi
    else
        # Linux / other
        # Try to install to /usr/local/bin
        sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
        sudo chmod a+rx /usr/local/bin/yt-dlp
    fi
}

install_ffmpeg() {
    echo "Attempting to install ffmpeg..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install ffmpeg
        else
            echo "Homebrew not found. Please install ffmpeg manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y ffmpeg
        elif command -v yum &> /dev/null; then
            sudo yum install -y ffmpeg
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y ffmpeg
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm ffmpeg
        else
            echo "Could not detect package manager. Please install ffmpeg manually."
            exit 1
        fi
    fi
}

# 1. Check and Install yt-dlp
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp not found."
    install_yt_dlp
else
    echo "yt-dlp is installed."
fi

# 2. Check and Install ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg not found."
    install_ffmpeg
else
    echo "ffmpeg is installed."
fi

# Re-check to ensure installation succeeded
if ! command -v yt-dlp &> /dev/null || ! command -v ffmpeg &> /dev/null; then
    echo "Error: Installation failed. Please install yt-dlp and ffmpeg manually."
    exit 1
fi

# 3. Setup Directory
DIR_NAME="YouTube_Downloads"
mkdir -p "$DIR_NAME"
cd "$DIR_NAME" || exit

echo "---------------------------------------------------"
echo "        YouTube Playlist Downloader"
echo "---------------------------------------------------"

# 4. Hardcoded User Input
playlist_url="https://youtube.com/playlist?list=PLuw94TOTVFeT2Exdgs0D0t7-hrhryQZnv&si=Wcv5MeSV8Exvnz8U"

echo "Target Playlist: $playlist_url"
echo "Format: Audio (MP3)"
echo "Starting download..."

# 5. Execute Audio Download
# -x: Extract audio
# --audio-format mp3: Convert to mp3
# -o: Output format (Number - Title.extension)
yt-dlp -x --audio-format mp3 -o "%(playlist_index)s - %(title)s.%(ext)s" "$playlist_url"

echo "---------------------------------------------------"
echo "Download complete! Files are in the '$DIR_NAME' folder."