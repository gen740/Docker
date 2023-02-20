docker run --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" --net="host" --name Main -p 8888:8888 -it main /bin/zsh
docker run --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" --net="host" --name Gazebo -p 8888:8888 -p 11345:11345 -it main /bin/zsh
