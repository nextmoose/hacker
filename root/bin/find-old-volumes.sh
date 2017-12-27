#!/bin/sh


docker volume ls --quiet | head -n 1 | while read VOLUME
do
    (cat <<EOF
CUTOFF=$(($(date +%s)-60*60*24*7)) &&
    find /volume -mindepth 1 | while read FILE1
    do
        stat -c %X "\${FILE1}"
    done | sort -u | tail -n 1 | while read LAST_ACCESSED
    do
        [ \${LAST_ACCESSED} -lt ${CUTOFF} ] &&
            find /volume -mindepth 1 | while read FILE2
            do
                stat -c %Y "\${FILE2}"
            done | sort -u | tail -n 1 | while read LAST_MODIFIED
            do
                [ \${LAST_MODIFIED} -lt ${CUTOFF} ] &&
                    find /volume -mindepth 1 | while read FILE3
                    do
                        stat -c %Z "\${FILE3}"
                    done | sort -u | tail -n 1 | while read LAST_CHANGED
                    do
                        [ \${LAST_CHANGED} -lt ${CUTOFF ] &&
                            echo \${VOLUME}
                    done
            done
    done &&
        echo \${VOLUME}
EOF
    ) | docker \
    container \
    run \
    --interactive \
    --rm \
    --label expiry=$(($(date +%s)+60*60*24*7)) \
    --volume ${VOLUME}:/volume:ro \
    --env VOLUME=${VOLUME} \
    alpine:3.4 \
        sh
done
