# Set keyboard layout to swedish
setxkbmap se

# Source the xmodmap file to add | for my iso layout keyboard
xmodmap ~/.Xmodmap

# Start dropboxd
dropboxd &

# Start compton with inactive dim
compton --config .config/compton.conf -b

awesome
