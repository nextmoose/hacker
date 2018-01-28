#!/bin/sh

docker container start $(docker container ls --quiet --filter label=project=7dccda58-5192-4c1c-8e03-75769a86df76)