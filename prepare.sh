#!/bin/zsh

## Remove EXIF Information From Images
echo "[*] Removing EXIF Information"
find static/img -type "f" ! -iname "*.svg" -exec mogrify -strip {} \;

## Spellchecker
echo "[*] Running Spellchecker"
cwd=$(pwd)
find content/posts/ -type "f" -name "*.md" -exec aspell --mode=markdown --lang=en --extra-dicts=$cwd/aspell.dict check {} \;

## Checks
echo "[!] CHECK DRAFT STATUS AND DATE!"
echo "[!] CHECK IF / WHETHER!"
echo "[!] WATERMARK PICTURES!"
echo "[!] CHECK PICTURES AND BLOG POST IN LIGHT MODE"

## Common mistakes
grep -r "Note, that"

if read -q "REPLY?Proceed?"; then
	## Build
	hugo
fi
