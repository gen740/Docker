docker run --cap-add=SYS_PTRACE --cap-add=SYS_ADMIN --security-opt="seccomp=unconfined" --net="host" --name Main -p 8888:8888 -it main /bin/zsh
docker run --cap-add=SYS_PTRACE --cap-add=SYS_ADMIN --security-opt="seccomp=unconfined" --net="host" --name Main -it main /bin/zsh


docker run --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" --name Gazebo3 -p 11345:11345 -it main /bin/zsh
docker run --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" --name Gazebo -it main /bin/zsh

DISPLAY=127.0.0.1:0


docker run --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" --name Gazebo4 -p 11345:11345 -v ~/.Xauthority:/home/gen740/.Xauthority -it main /bin/zsh


export DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
https://github.com/chanezon/docker-tips/blob/master/x11/README.md


```
function startx() {
	if [ -z "$(ps -ef|grep XQuartz|grep -v grep)" ] ; then
	    open -a XQuartz
        socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
	fi
}
```

# Dummy display client
sudo apt-get install xserver-xorg-video-dummy

https://askubuntu.com/questions/453109/add-fake-display-when-no-monitor-is-plugged-in

/usr/bin/Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./xdummy.log -config /etc/X11/xorg.conf :1





curl -sSL http://get.gazebosim.org | sh

sudo apt install xserver-xorg-video-dummy

``` dummy-1920x1080.conf
Section "Monitor"
  Identifier "Monitor0"
  HorizSync 28.0-80.0
  VertRefresh 48.0-75.0
  # https://arachnoid.com/modelines/
  # 1920x1080 @ 60.00 Hz (GTF) hsync: 67.08 kHz; pclk: 172.80 MHz
  Modeline "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
EndSection
Section "Device"
  Identifier "Card0"
  Driver "dummy"
  VideoRam 256000
EndSection
Section "Screen"
  DefaultDepth 24
  Identifier "Screen0"
  Device "Card0"
  Monitor "Monitor0"
  SubSection "Display"
    Depth 24
    Modes "1920x1080_60.00"
  EndSubSection
EndSection
```

sudo X -config dummy-1920x1080.conf

export DISPLAY=:0



## GAZEBO

sudo apt install ruby

-> clone
https://github.com/gazebosim/sdformat.git
-> checkout sdformat9_9.8.0

-> mkdir build ... ninja install

-> clone
https://github.com/osrf/gazebo -> switch gazebo11_11.12.0 (macos version)

cmake -DCMAKE_INSTALL_PREFIX=~/.local
-> mkdir build .. ninja install


-> git clone https://github.com/dartsim/dart.git
git checkout tags/v6.13
-> mkdir build ... ninja install
