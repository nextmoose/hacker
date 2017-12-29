#!/bin/sh

mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    touch /home/user/.ssh/known_hosts &&
    chmod 0644 /home/user/.ssh/known_hosts &&
    touch /home/user/.ssh/{lieutenant.id_rsa,pavillion.id_rsa} &&
    cp /opt/docker/extension/config /home/user/.ssh/config &&
    chmod 0600 /home/user/{config,lieutenant.id_rsa,pavillion.id_rsa}