#!/bin/sh

xhost +local: &&
    dckr(){
        sudo --preserve-env docker run --interactive --tty --rm docker:17.12.0-ce "${@}"
    }
    export EXTERNAL_DOCKER_VOLUME=$(docker volume create --label expiry=$(($(date +%s)+60*60*24*7))) &&
    export EXTERNAL_DOCKER_NETWORK=$(docker network create --label expiry=$(($(date +%s)+60*60*24*7)) $(uuidgen))
    cleanup(){
        docker volume rm ${EXTERNAL_DOCKER_VOLUME} &&
            docker network rm ${EXTERNAL_DOCKER_NETWORK} &&
            xhost
    } &&
    trap cleanup EXIT &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --gpg-secret-key)
                export GPG_SECRET_KEY="${2}" &&
                    shift 2
            ;;
            --gpg2-secret-key)
                export GPG2_SECRET_KEY="${2}" &&
                    shift 2
            ;;
            --gpg-owner-trust)
                export GPG_OWNER_TRUST="${2}" &&
                    shift 2
            ;;
            --gpg2-owner-trust)
                export GPG2_OWNER_TRUST="${2}" &&
                    shift 2
            ;;
            --hacker-version)
                HACKER_VERSION="${2}" &&
                    shift 2
            ;;
            *)
                echo Unknown Option &&
                    echo ${0} &&
                    echo ${@} &&
                    exit 64
            ;;
        esac
    done &&
    sudo \
        --preserve-env \
        docker \
        container \
        create \
        --interactive \
        --tty \
        --cidfile ${IDS}/containers/hacker \
        --env PROJECT_NAME="my-hacker" \
        --env CLOUD9_PORT="10379" \
        --env DISPLAY="${DISPLAY}" \
        --env EXTERNAL_NETWORK_NAME="$(cat ${IDS}/networks/main)" \
        --env USER_NAME="Emory Merryman" \
        --env USER_EMAIL="emory.merryman@gmail.com" \
        --env ORIGIN_ID_RSA \
        --env GPG_SECRET_KEY \
        --env GPG2_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG2_OWNER_TRUST \
        --env GPG_KEY_ID=D65D3F8C \
        --env SECRETS_ORIGIN_ORGANIZATION=nextmoose \
        --env SECRETS_ORIGIN_REPOSITORY=secrets \
        --env EXTERNAL_DOCKER_VOLUME=$(cat ${IDS}/volumes/docker) \
        --privileged \
        --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
        --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
        --mount type=bind,source=/,destination=/srv/host,readonly=true \
        --mount type=bind,source=/media,destination=/srv/media,readonly=false \
        --mount type=bind,source=/home,destination=/srv/home,readonly=false \
        --mount type=volume,source=$(cat ${IDS}/volumes/storage),destination=/srv/storage,readonly=false \
        --mount type=volume,source=$(cat ${IDS}/volumes/docker),destination=/srv/docker,readonly=false \
        --label expiry=$(($(date +%s)+60*60*24*7)) \
        rebelplutonium/hacker:${HACKER_VERSION} &&
    sudo \
        --preserve-env \
        docker \
        container \
        create \
        --cidfile ${IDS}/containers/browser \
        --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
        --mount type=volume,source=$(cat ${IDS}/volumes/storage),destination=/srv/storage,readonly=false \
        --env DISPLAY=${DISPLAY} \
        --shm-size 256m \
        --label expiry=$(($(date +%s)+60*60*24*7)) \
        rebelplutonium/browser:0.0.0 \
            http://my-hacker:10379 &&
    sudo /usr/bin/docker network connect $(cat ${IDS}/networks/main) $(cat ${IDS}/containers/browser) &&
    sudo /usr/bin/docker network connect --alias my-hacker $(cat ${IDS}/networks/main) $(cat ${IDS}/containers/hacker) &&
    sudo /usr/bin/docker container start $(cat ${IDS}/containers/browser) &&
    sudo /usr/bin/docker container start --interactive $(cat ${IDS}/containers/hacker)