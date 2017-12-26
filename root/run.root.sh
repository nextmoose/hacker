#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes dnf-plugins-core sudo &&
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf install --assumeyes docker-common docker-latest &&
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    dnf clean all