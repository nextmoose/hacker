#!/bin/sh

mkdir /srv/ids &&
    mkdir /srv/ids/{containers,images,networks,volumes} &&
    chown user:user /srv/ids/{containers,images,networks,volumes}