/usr/X11/bin/xhost +

docker run --rm                                 \
    -v ~/.Xauthority:/home/gen740/.Xauthority   \
    -e DISPLAY=docker.for.mac.host.internal:0   \
    gen740/ubuntu-22.04-desktop /usr/bin/firefox
