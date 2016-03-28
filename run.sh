#!/bin/bash
MAPUID=$(id -u)
MAPGID=$(id -g)
BIND_IP=192.168.1.202
docker run -ti --rm \
   -e "AGREE_TO_EULA=true" \
   -e "USERMAP_UID=${MAPUID}" -e "USERMAP_GID=${MAPGID}" \
   -v $(pwd)/data:/home/minecraft/data \
   -p ${BIND_IP}:25565:25565 \
   --name "vanilla" \
   susero/minecraft_server-vanilla $@
