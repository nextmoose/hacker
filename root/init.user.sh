#!/bin/sh

source ${HOME}/.bashrc &&
    (cat <<EOF
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_DEFAULT_REGION}

EOF
    ) | aws configure &&
    sed \
        -e "s#\${LIEUTENANT_PUBLIC_IP_ADDRESS}#$(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query \"Reservations[*].Instances[*].PublicIpAddress\" --output text)#" \
        -e "s#\${HOST_NAME}#${HOST_NAME}#" \
        -e "s#\${HOST_PORT}#${HOST_PORT}#" \
        -e "w/home/user/.ssh/config" \
        /opt/docker/extension/config &&
    echo "${ORIGIN_ID_RSA}" > /home/user/.ssh/origin.id_rsa &&
    echo "${UPSTREAM_ID_RSA}" > /home/user/.ssh/upstream.id_rsa &&
    echo "${REPORT_ID_RSA}" > /home/user/.ssh/report.id_rsa &&
    echo "${LIEUTENANT_AWS_PRIVATE_KEY}" > /home/user/.ssh/lieutenant-ec2.id_rsa &&
    ssh-keyscan -p ${HOST_PORT} "${HOST_NAME}" >> /home/user/.ssh/known_hosts &&
    ssh-keyscan $(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query \"Reservations[*].Instances[*].PublicIpAddress\" --output text) >> /home/user/.ssh/known_hosts &&
    ln -sf /home/user/.ssh /opt/docker/workspace/dot_ssh &&
    TEMP=$(mktemp -d) &&
    echo "${GPG_SECRET_KEY}" > ${TEMP}/gpg-secret-key &&
    gpg --batch --import ${TEMP}/gpg-secret-key &&
    echo "${GPG2_SECRET_KEY}" > ${TEMP}/gpg2-secret-key &&
    gpg2 --batch --import ${TEMP}/gpg2-secret-key &&
    echo "${GPG_OWNER_TRUST}" > ${TEMP}/gpg-owner-trust &&
    gpg --batch --import-ownertrust ${TEMP}/gpg-owner-trust &&
    echo "${GPG2_OWNER_TRUST}" > ${TEMP}/gpg2-owner-trust &&
    gpg2 --batch --import-ownertrust ${TEMP}/gpg2-owner-trust &&
    rm -rf ${TEMP} &&
    pass init ${GPG_KEY_ID} &&
    pass git init &&
    pass git config user.name "${USER_NAME}" &&
    pass git config user.email "${USER_EMAIL}" &&
    pass git remote add origin origin:${SECRETS_ORIGIN_ORGANIZATION}/${SECRETS_ORIGIN_REPOSITORY}.git &&
    echo "${ORIGIN_ID_RSA}" > /home/user/.ssh/origin_id_rsa &&
    pass git fetch origin master &&
    pass git checkout master &&
    cp /opt/docker/extension/post-commit.sh ${HOME}/.password-store/.git/hooks/post-commit &&
    chmod 0500 ${HOME}/.password-store/.git/hooks/post-commit &&
    mkdir /opt/docker/workspace/ec2-user &&
    sshfs -o allow_other lieutenant-ec2:/data /opt/docker/workspace/ec2-user/