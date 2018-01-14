#!/bin/sh

CIDFILE=$(mktemp /srv/ids/containers/XXXXXXXX) &&
    export PROJECT_NAME="${@}" &&
    rm ${CIDFILE} &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --env PROJECT_NAME=${PROJECT_NAME} \
        --env CLOUD9_PORT=10380 \
        --env UPSTREAM_ID_RSA="$(pass show upstream.id_rsa)" \
        --env UPSTREAM_ORGANIZATION=rebelplutonium \
        --env UPSTREAM_REPOSITORY=github \
        --env ORIGIN_ID_RSA="$(pass show upstream.id_rsa)" \
        --env ORIGIN_ORGANIZATION=nextmoose \
        --env ORIGIN_REPOSITORY=github \
        --env REPORT_ID_RSA="$(pass show report.id_rsa)" \
        --env REPORT_ORGANIZATION=rebelplutonium \
        --env REPORT_REPOSITORY=github \
        --env USER_NAME="${USER_NAME}" \
        --env USER_EMAIL="${USER_EMAL}" \
        --env HOST_NAME=github.com \
        --env HOST_PORT=22 \
        --env MASTER_BRANCH=master \
        rebelplutonium/github:0.0.4 &&
    docker network connect --alias ${PROJECT_NAME} ${EXTERNAL_NETWORK_NAME} $(cat ${CIDFILE}) &&
    docker container start $(cat ${CIDFILE})