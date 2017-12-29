#!/bin/sh

pip install awscli --upgrade --user &&
    echo "export PATH=\${HOME}/.local/bin:\${PATH}" >> ${HOME}/.bashrc &&
    mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    touch /home/user/.ssh/known_hosts &&
    chmod 0644 /home/user/.ssh/known_hosts &&
    cp /opt/docker/extension/config /home/user/.ssh/config &&
    touch /home/user/.ssh/{lieutenant.id_rsa,pavillion.id_rsa} &&
    chmod 0600 /home/user/.ssh{config,lieutenant.id_rsa,pavillion.id_rsa}