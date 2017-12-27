#!/bin/sh

echo "${VOLUMES_BACKUP_PRIVATE_KEY}" > /home/user/.ssh/volumes-backup-id-rsa &&
    echo "export AGE_DELTA=$((60*60*24*7*4*5))" >> /home/user/.bashrc