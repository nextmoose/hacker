#!/bin/sh

echo "${HACKER_2_LIEUTENANT_PRIVATE_KEY}" > /home/user/.ssh/lieutenant_id_rsa &&
    ssh-keyscan 34.229.36.153 >> /home/user/.ssh/known_hosts &&
    echo "${VOLUMES_BACKUP_PRIVATE_KEY}" > /home/user/.ssh/volumes-backup-id-rsa &&
    echo "export AGE_DELTA=$((60*60*24*7*4*5))" >> /home/user/.bashrc