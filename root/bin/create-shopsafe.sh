#!/bin/sh

docker container create --label expiry=$(($(date +%s)+60*60*24*7)) --label project=7dccda58-5192-4c1c-8e03-75769a86df76 --volume ${VOLUME}:/home rebelplutonium/shopsafe:0.0.5