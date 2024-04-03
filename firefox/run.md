/usr/X11/bin/xhost +

docker run --rm -it                           \
    -v ~/.Xauthority:/home/gen740/.Xauthority \
    -e DISPLAY=docker.for.mac.host.internal:0 \
    firefox /bin/sh
