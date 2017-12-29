#!/bin/sh

source ${HOME}/.bashrc &&
    (cat <<EOF
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_DEFAULT_REGION}

EOF
    ) | aws configure &&
    echo "${HACKER_2_LIEUTENANT_PRIVATE_KEY}" > /home/user/.ssh/lieutenant.id_rsa &&
    echo "${HACKER_2_PAVILLION_PRIVATE_KEY}" > /home/user/.ssh/pavillion.id_rsa &&
    ssh-keyscan 34.229.36.153 >> /home/user/.ssh/known_hosts &&
    ln -sf /home/user/.ssh /opt/docker/workspace/dot_ssh &&
    echo "${VOLUMES_BACKUP_PRIVATE_KEY}" > /home/user/.ssh/volumes-backup-id-rsa &&
    echo "export AGE_DELTA=$((60*60*24*7*4*5))" >> /home/user/.bashrc