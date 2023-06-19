#Download and install nerdfont
# From https://github.com/ryanoasis/nerd-fonts

# Cheat sheet
# https://www.nerdfonts.com/cheat-sheet
set -e
#!/bin/bash
FONT='Hack'
TMP_ZIP_PATH="/tmp/${FONT}.zip"
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"$FONT".zip -O "$TMP_ZIP_PATH"
unzip  "$TMP_ZIP_PATH" -d ~/.local/share/fonts/hack
echo $
rm "$TMP_ZIP_PATH"
fc-cache -fv
