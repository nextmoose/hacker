#!/bin/sh

(cat <<EOF
find /volumes -mindepth 2 | while read FILE
do
    echo stat -c "%n %x" \${FILE}
done
EOF
) | docker \
    container \
    run \
    --interactive \
    --rm \
    --label expiry=$(($(date +%s)+60*60*24*7)) \
    $(docker volume ls --quiet --filter dangling=false | while read VOLUME; do echo "--volume ${VOLUME}:/volumes/${VOLUME}:ro"; done) \
    alpine:3.4 \
        sh
