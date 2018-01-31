#!/bin/sh

rsync \
    --archive \
    --verbose \
    --delete \
    --remove-source-files \
    /home/t8k3hcc7xdo3ww/Dropbox/zips \
    ec2:/data