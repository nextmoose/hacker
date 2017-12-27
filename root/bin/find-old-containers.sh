#!/bin/sh

docker container ls --all --quiet --filter status=exited | while read CONTAINER
do
    if [ $(date --date $(docker container inspect --format "{{.State.FinishedAt}}" ${CONTAINER}) +%s) -lt $(($(date +%s)-60*60*24*7*13)) ]
    then
        echo ${CONTAINER}
    fi
done