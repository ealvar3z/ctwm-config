#!/bin/sh
set -eu

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$HOME/bin"
cp "$DIR/home/.ctwmrc" "$HOME/.ctwmrc"
cp "$DIR/home/.Xresources" "$HOME/.Xresources"
cp "$DIR/home/.xinitrc" "$HOME/.xinitrc"
cp "$DIR/bin/acme-term" "$HOME/bin/acme-term"
chmod +x "$HOME/.xinitrc" "$HOME/bin/acme-term"

cat <<'MSG'
Installed CTWM Acme desktop files into your home directory.
Start it with:
    startx

Useful keys:
    Alt-Return  terminal
    Alt-a       acme
    Alt-m       root menu
    Alt-w       window menu
    Alt-n/p     next/previous workspace
    Alt-Tab     next window in ring
    Alt-f       full zoom
    Alt-i       iconify
    Ctrl-Alt-r  restart ctwm
    Ctrl-Alt-q  quit X
MSG
