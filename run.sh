#!/bin/bash
MAPUID=$(id -u)
MAPGID=$(id -g)
docker run -ti --rm \
   -e "AGREE_TO_EULA=true" \
   -e "USERMAP_UID=${MAPUID}" -e "USERMAP_GID=${MAPGID}" \
   -v $(pwd)/data:/home/minecraft/data \
   -P \
   --name "vanilla" \
   susero/minecraft_server-vanilla $@
