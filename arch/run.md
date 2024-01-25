docker run --cap-add=SYS_PTRACE --cap-add=SYS_ADMIN --security-opt="seccomp=unconfined" --net="host" --name Main -p 8888:8888 -it main-arch /bin/zsh
docker exec -it Main /bin/zsh
