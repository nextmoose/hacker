#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes dnf-plugins-core sudo &&
    dnf install --assumeyes python2-pip &&
    dnf install --assumeyes gnupg gnupg pass findutils bash-completion &&
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf install --assumeyes docker-common docker-latest &&
    dnf install --assumeyes man &&
    dnf install --assumeyes paperkey a2ps &&
    dnf install --assumeyes fuse-sshfs &&
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    dnf clean all