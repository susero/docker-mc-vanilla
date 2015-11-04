#!/bin/bash
MAPUID=$(id -u)
MAPGID=$(id -g)
docker run -ti --rm -e "AGREE_TO_EULA=true" -e "USERMAP_UID=${MAPUID}" -e "USERMAP_GID=${MAPGID}" -v $(pwd)/data:/opt/minecraft -p 192.168.1.201:25565:25565 --name "minecraft-server" susero/minecraft-server $@
