#!/bin/bash

# clear the screen
clear

# avoid some implicit errors
set -euo pipefail
shopt -s nullglob

# title of the script
echo '
----------------------------------------------------------------
       ░█▀▀░█▀█░█▀▀░█░█░█▀▀░░░█▀▀░█░░░█▀▀░█▀█░█▀█░█░█░█▀█
       ░█░░░█▀█░█░░░█▀█░█▀▀░░░█░░░█░░░█▀▀░█▀█░█░█░█░█░█▀▀
       ░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░
----------------------------------------------------------------
'

# clean pacman cache
echo '==> Cleaning pacman cache...'
sudo pacman -Sc
sudo pacman -Scc
yay -Sc
yay -Scc
echo '
----------------------------------------------------------------
'

# find and remove orphan packages
pkglist=$(pacman -Qdtq 2>/dev/null || echo '')
orphans=$(echo "$pkglist" | tr '\n' ' ' | xargs)
if [ -n "$orphans" ]; then
    echo 'Orphan packages detected:'
    echo "$orphans"
    echo '==> Cleaning orphan packages...'
    sudo pacman -Rcuns "$orphans"
else
    echo 'No orphan packages found.'
fi
echo '
----------------------------------------------------------------
'

# clean .cache folder in HOME directory
CACHE_DIR="$HOME/.cache"
echo 'Cache size before cleanup:'
du -sh "$CACHE_DIR"
echo "==> Removing all files in $CACHE_DIR..."
rm -rf "$CACHE_DIR"/*
echo 'Cache size after cleanup:'
du -sh "$CACHE_DIR"
echo '
----------------------------------------------------------------
'

# remove all .bash_history*.tmp files in HOME
tmpfiles=("$HOME"/.bash_history*.tmp)
if (( ${#tmpfiles[@]} )); then
    echo '==> Removing temporary bash history files...'
    rm -v "${tmpfiles[@]}"
else
    echo 'No temporary bash history files found.'
fi

echo '
----------------------------------------------------------------
'

# script completed
echo 'Cleanup complete!'
