#!/bin/bash
scversion="stable" # or "v0.4.7", or "latest"
wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJ
DIR_SHELLCHECK="shellcheck-${scversion}/shellcheck"
cp  "$DIR_SHELLCHECK" "/${HOME}/bin/"
rm -r "$(dirname "$DIR_SHELLCHECK")"
printf "Install success \n\n"
shellcheck --version
