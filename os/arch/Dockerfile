FROM archlinux:latest
LABEL maintaine="sam j tro"
RUN ["/bin/bash","-c", "pacman --noconfirm -Syy && pacman --noconfirm -Syu && pacman --noconfirm -S bash git vim sudo curl gnupg wget xorg-server-xvfb python python-pip go jdk-openjdk jre-openjdk && locale-gen en_US.UTF-8 && mkdir /home/user"]
