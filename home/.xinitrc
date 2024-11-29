nitrogen --restore
# change togle 
setxkbmap -layout us,ru -option grp:caps_toggle
picom --daemon --backend glx --vsync --config picom.conf
./lemon &
# change xrandr input (monitor, framerate)
xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00
dunst -conf .config/leftwm/themes/current/dunstrc.tmpl &
exec leftwm

