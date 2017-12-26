#!/bin/sh

mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    touch /home/user/.ssh/volumes-backup-id-rsa &&
    chmod 0600 /home/user/.ssh/config /home/user/.ssh/volumes-backup-id-rsa