#!/bin/bash
docker run -ti -e AGREE_TO_EULA=true -v $(pwd)/data:/opt/minecraft -p 192.168.1.201:25565:25565 --name "minecraft-server" susero/minecraft-server $@
