#!/bin/sh

docker \
    container \
    create \
    --label expiry=$(($(date +%s)+60*60*24*7)) \
    --label project=7dccda58-5192-4c1c-8e03-75769a86df76 \
    --volume /tmp/.X101-unix/X0:/tmp/.X11-unix:X0:ro \
    --env DISPLAY \
    rebelplutonium/shopsafe:0.0.5