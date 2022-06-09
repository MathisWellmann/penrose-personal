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

# xrandr --output DVI-D-0 --rotate left && 
# xrandr --output DP-0 --rotate left --right-of DVI-D-0 &&
# xrandr --output HDMI-0 --rotate left --left-of DVI-D-0 &&
setxkbmap de &&
rust-dwm-status &
nitrogen --set-zoom-fill --random ~/wallpapers &
exec penrose-personal

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
