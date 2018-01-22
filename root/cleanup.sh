#!/bin/sh

ls -1 /srv/dockers/containers | while read FILE
do
    sudo /usr/bin/docker container stop $(cat /srv/dockers/containers/${FILE}) &&
        sudo /usr/bin/docker container rm --volumes $(cat /srv/dockers/containers/${FILE}) &&
        rm -f /srv/dockers/${FILE}
done &&
    ls -1 /srv/dockers/images | while read FILE
    do
        sudo /usr/bin/docker image rm $(cat /srv/dockers/images/${FILE}) &&
            rm -f /srv/dockers/${FILE}
    done &&
    ls -1 /srv/dockers/networks | while read FILE
    do
        sudo /usr/bin/docker network rm $(cat /srv/dockers/networks/${FILE}) &&
            rm -f /srv/dockers/${FILE}
    done &&
    ls -1 /srv/dockers/volumes | while read FILE
    do
        sudo /usr/bin/docker volume rm $(cat /srv/dockers/volumes/${FILE}) &&
            rm -f /srv/dockers/${FILE}
    done
        