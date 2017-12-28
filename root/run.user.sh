#!/bin/sh

mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    touch /home/user/.ssh/known_hosts &&
    chmod 0644 /home/user/.ssh/known_hosts &&
    touch /home/user/.ssh/lieutenant_id_rsa &&
    cp /opt/docker/extension/config /home/user/.ssh/config &&
    touch /home/user/.ssh/volumes-backup-id-rsa &&
    chmod 0600 /home/user/.ssh/config /home/user/.ssh/lieutenant_id_rsa /home/user/.ssh/volumes-backup-id-rsa