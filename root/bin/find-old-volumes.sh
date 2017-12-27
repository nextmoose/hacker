#!/bin/sh


docker volume ls --quiet | head -n 1 | while read VOLUME
do
    (cat <<EOF
last_x(){
    find /volume -mindepth 1 | while read FILE
    do
        stat -c %${1} "\${FILE}"
    done | sort -u | tail -n 1
    EOF
        ) | docker \
            container \
            run \
            --label expiry=$(($(date +%s)+60*60*24*7)) \
            --interactive \
            --rm \
            --volume ${VOLUME}:/volume:ro \
            --env VOLUME=${VOLUME} \
            alpine:3.4 \
                sh
    done
} &&
    if [ $(last_x X) -lt $(($(date +%s)-60*60*24*7)) ] && [ $(last_x Y) -lt $(($(date +%s)-60*60*24*7)) ] && [ $(last_x Z) -lt $(($(date +%x)-60*60*24*7)) ]
    then
        echo \${VOLUME}
    fi
EOF
) | docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --label expiry=$(($(date +%s)+60*60*24*7)) \
    $(docker volume ls --quiet --filter dangling=false | head -n 10 | while read VOLUME; do echo "--volume ${VOLUME}:/volumes/${VOLUME}:ro"; done) \
    alpine:3.4 \
        sh
