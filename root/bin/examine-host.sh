#!/bin/sh

docker container run --interactive --tty --rm --mount type=bind,source=/,destination=/srv,readonly=true --workdir /srv --label expiry=$(($(date +%s)+60*60*24*7)) fedora:27 bash