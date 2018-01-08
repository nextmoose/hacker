#!/bin/sh

xhost +local: &&
    TEMP_DIR=$(mktemp -d) &&
    mkdir ${TEMP_DIR}/containers &&
    mkdir ${TEMP_DIR}/networks &&
    mkdir ${TEMP_DIR}/volumes &&
    cleanup(){
        ls -1 ${TEMP_DIR}/containers | while read FILE
        do
            docker container stop $(cat ${TEMP_DIR}/containers/${FILE}) &&
                docker container rm --volumes $(cat ${TEMP_DIR}/containers/${FILE})
        done &&
        ls -1 ${TEMP_DIR}/networks | while read FILE
        do
            docker network rm $(cat ${TEMP_DIR}/networks/${FILE})
        done &&
        ls -1 ${TEMP_DIR}/volume | while read FILE
        do
            docker volume rm $(cat ${TEMP_DIR}/volumes/${FILE})
        done &&
        rm -rf ${TEMP_DIR} &&
        xhost
    } &&
    trap cleanup EXIT &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --hacker-version)
                HACKER_VERSION="${2}" &&
                    shift 2
            ;;
            --use-versioned-hacker-secrets)
                USE_VERSIONED_HACKER_SECRETS=yes &&
                    shift
            ;;
            *)
                echo Unknown Option &&
                    echo ${0} &&
                    echo ${@} &&
                    exit 64
            ;;
        esac
    done &&
    docker volume create --label expiry=$(($(date +%s)+60*60*24*7)) > ${TEMP_DIR}/volumes/storage &&
    docker \
        container \
        create \
        --cidfile ${TEMP_DIR}/containers/browser \
        --mount --type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
        --mount --type=volume,source=$(cat ${TEMP_DIR}/volumes/storage),destination=/srv/storage,readonly=false \
        --label expiry=$(($(date +%s)+60*60*24*7)) \
        rebelplutonium/browser:0.0.0 &&
    export ORIGIN_ID_RSA="$(cat private/origin.id_rsa)" &&
    export GPG_SECRET_KEY="$(cat private/gpg-secret-key)" &&
    export GPG2_SECRET_KEY="$(cat private/gpg2-secret-key)" &&
    export GPG_OWNER_TRUST="$(cat private/gpg-owner-trust)" &&
    export GPG2_OWNER_TRUST="$(cat private/gpg2-owner-trust)" &&
    docker \
        container \
        create \
        --cidfile ${TEMP_DIR}/containers/hacker \
        --env PROJECT_NAME="my-hacker" \
        --env CLOUD9_PORT="10379" \
        --env DISPLAY \
        --env EXTERNAL_NETWORK_NAME \
        --env USER_NAME="Emory Merryman" \
        --env USER_EMAIL="emory.merryman@gmail.com" \
        --env ORIGIN_ID_RSA \
        --env GPG_SECRET_KEY \
        --env GPG2_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG_KEY_ID=D65D3F8C \
        --env SECRETS_ORIGIN_ORGANIZATION=nextmoose \
        --env SECRETS_ORIGIN_REPOSITORY=secrets \
        --privileged \
        --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
        --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
        --mount type=bind,source=/,destination=/srv/host,readonly=true \
        --mount type=bind,source=/media,destination=/srv/media,readonly=false \
        --mount type=bind,source=/home,destination=/srv/home,readonly=false \
        --mount --type=volume,source=$(cat ${TEMP_DIR}/volumes/storage),destination=/srv/storage,readonly=false \
        --label expiry=$(($(date +%s)+60*60*24*7)) \
        rebelplutonium/hacker:0.0.12 &&
    docker network create --label expiry=$(($(date +%s)+60*60*24*7)) $(uuidgen) > ${TEMP_DIR}/networks/main &&
    docker network connect $(cat ${TEMP_DIR}/networks/main) $(cat ${TEMP_DIR}/containers/browser) &&
    docker network connect -alias hacker $(cat ${TEMP_DIR}/networks/main) $(cat ${TEMP_DIR}/containers/hacker) &&
    docker container start $(cat ${TEMP_DIR}/browser) &&
    docker container start $(cat ${TEMP_DIR}/hacker)