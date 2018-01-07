#!/bin/sh

xhost +local: &&
    TEMP_DIR=$(mktemp -d) &&
    mkdir ${TEMP_DIR}/containers &&
    mkdir ${TEMP_DIR}/networks &&
    cleanup(){
        ls -1 ${TEMP_DIR}/containers | while read FILE
        do
            docker container stop $(cat ${TEMP_DIR}/containers/${FILE}) &&
                docker container rm --volumes $(cat ${TEMP_DIR}/containers/${FILE})
        done &&
        ls -1 ${TEMP_DIR}/networks | while read FILE
        do
            docker network stop $(cat ${TEMP_DIR}/networks/${FILE})
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
    docker \
        container \
        create \
        --
        
        
          the_browser:
    image: rebelplutonium/browser:0.0.0
    privileged: true
    shm_size: "256m"
    environment:
      DISPLAY:
    volumes:
      - "/tmp/.X11-unix:/tmp/.X11-unix:ro"
    networks:
      main:
    command:
      - "http://governor:16842"
      - "http://browser:16843"
      - "http://cloud9:16843"
      - "http://github:16843"
      - "http://governor:16843"
      - "http://secret-editor:16843"
      - "http://hacker:16843"
      - "http://governor-secrets:16844"
      - "http://my-hacker:16844"
    docker network create $(uuidgen) > ${TEMP_DIR}/networks/main &&


    xhost +local: &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --governor-version)
                GOVERNOR_VERSION="${2}" &&
                    shift 2
            ;;
            --use-versioned-governor-secrets)
                USE_VERSIONED_GOVERNOR_SECRETS=yes &&
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
    export EXTERNAL_NETWORK_NAME=$(uuidgen) &&
    export EXPIRY=$(($(date +%s)+60*60*24*7)) &&
    sudo docker network create --label expiry=${EXPIRY} ${EXTERNAL_NETWORK_NAME} &&
    cleanup(){
        sudo docker network rm ${EXTERNAL_NETWORK_NAME}
    } &&
    trap cleanup EXIT &&
    sudo \
        docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --name governor \
        --network ${EXTERNAL_NETWORK_NAME} \
        --env EXTERNAL_NETWORK_NAME=${EXTERNAL_NETWORK_NAME} \
        --env PROJECT_NAME=governor \
        --env CLOUD9_PORT=16842 \
        --env USER_NAME="Emory Merryman" \
        --env USER_EMAIL=emory.merryman@gmail.com \
        --env GOVERNOR_SECRETS_HOST_NAME=github.com \
        --env GOVERNOR_SECRETS_HTTPS_HOST_PORT=443 \
        --env GOVERNOR_SECRETS_SSH_HOST_PORT=22 \
        --env GOVERNOR_SECRETS_ORIGIN_ORGANIZATION=nextmoose \
        --env GOVERNOR_SECRETS_ORIGIN_REPOSITORY=secrets \
        --env USE_VERSIONED_GOVERNOR_SECRETS=${USE_VERSIONED_GOVERNOR_SECRETS} \
        --env GPG_KEY_ID=D65D3F8C \
        --env GPG_SECRET_KEY="$(cat private/gpg_secret_key)" \
        --env GPG2_SECRET_KEY="$(cat private/gpg2_secret_key)" \
        --env GPG_OWNER_TRUST="$(cat private/gpg_owner_trust)" \
        --env GPG2_OWNER_TRUST="$(cat private/gpg2_owner_trust)" \
        --env EXPIRY=${EXPIRY} \
        --label expiry=${EXPIRY} \
        --env DISPLAY \
        --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
        rebelplutonium/governor:${GOVERNOR_VERSION}