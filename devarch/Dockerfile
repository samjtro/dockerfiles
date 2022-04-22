FROM archlinux:latest
LABEL maintainer="Samuel Troyer"
RUN ["/bin/bash", "-c", "pacman --noconfirm -Syy && pacman --noconfirm -Syu && pacman --noconfirm -S bash git vim sudo curl gnupg wget python python-pip go jdk-openjdk jre-openjdk && locale-gen en_US.UTF-8 && mkdir /home/dev"]

