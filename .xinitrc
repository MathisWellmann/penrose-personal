#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)


if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrandr --output DP-2 --rotate left && 
xrandr --output DP-0 --rotate left --right-of DP-2 &&
xrandr --output DP-4 --rotate left --left-of DP-2 &&

polybar &
picom &
nitrogen --set-zoom-fill --random ~/wallpapers &
exec penrose-personal
