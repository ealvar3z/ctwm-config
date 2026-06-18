#!/bin/sh

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/local/plan9/bin:$PATH"
export PLAN9=/usr/local/plan9
export EDITOR=E
export BROWSER=firefox

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
xsetroot -solid '#FFFFEA' -cursor_name left_ptr
xset b off

if command -v 9 >/dev/null 2>&1; then
        pgrep -u "$USER" -f 'plumber' >/dev/null 2>&1 || 9 plumber >/tmp/plumber."$USER".log 2>&1 &
fi

xterm -name acme-term -title '+Errors' -geometry 100x28+20+70 &
xclock -analog -geometry 120x120-10+10 &

exec ctwm --nowelcome --nom4
