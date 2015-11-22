#!/bin/bash

USERNAME=minecraft

# PARAMS
AGREE_TO_EULA=${AGREE_TO_EULA:-false}
JVM_MX=${JVM_MX:-1G}
JVM_MS=${JVM_MS:-1024M}
JVM_BITS=${JVM_BITS:-}
JVM_CORES=${JVM_CORES:-}
JVM_OPTIMIZE=${JVM_OPTIMIZE:-true}
SYSTEM_TIMEZONE=${SYSTEM_TIMEZONE:-Asia/Tokyo}
USERMAP_UID=${USERMAP_UID:-$(id -u minecraft)}
USERMAP_GID=${USERMAP_GID:-$(id -g minecraft)}

HOME_DIR=$(eval echo ~$USERNAME)
DATA_DIR=${HOME_DIR}/data
GAME_DIR=${DATA_DIR}/game
ASSETS_DIR=${DATA_DIR}/assets

# SETUP SYSTEM TIMEZONE
if [ ! -e /usr/share/zoneinfo/${SYTEM_TIMEZONE} ]; then
   echo "Invalid timezone name or broken system."
   exit 1
fi
echo "${SYSTEM_TIMEZONE}" > /etc/timezone
cp /usr/share/zoneinfo/${SYSTEM_TIMEZONE} /etc/localtime

if [ ! -e ${ASSETS_DIR}/minecraft_server*.jar ]; then
   echo "You need download server.jar file on yourself and put it in assets direcotory."
   exit 1
fi
JARFILE=$(find ${ASSETS_DIR} -name minecraft_server\*.jar | head -n 1)
echo "Use $(basename $JARFILE)"

[ -d ${GAME_DIR} ] || mkdir -p ${GAME_DIR}
cd ${GAME_DIR}
if [ ! -e eula.txt ]; then
cat > eula.txt <<EOF
eula=${AGREE_TO_EULA}
EOF
else
   echo updating sign to eula
   sed -i -e "s/eula=.*/eula=${AGREE_TO_EULA}/" eula.txt
fi
[ $(id -u $USERNAME) -eq ${USERMAP_UID} ] || usermod -u ${USERMAP_UID} $USERNAME
[ $(id -g $USERNAME) -eq ${USERMAP_GID} ] || usermod -g ${USERMAP_GID} $USERNAME

chown -R minecraft.minecraft ${HOME_DIR}

if [ $# -eq 0 ]; then
   JVM_OPTS=
   [ -z $JVM_BITS ] || JVM_OPTS="$JVM_OPTS -d$JVM_BITS"
   [ -z $JVM_CORES ] || JVM_OPTS="$JVM_OPTS -XX:ParallelGCThreads=$JVM_CORES"
   [ "$JVM_OPTIMIZE" == "true" ] && JVM_OPTS="$JVM_OPTS -XX:+AggressiveOpts"
   sudo -u $USERNAME java -Xms${JVM_MS} -Xmx${JVM_MX} ${JVM_OPTS} -jar $JARFILE nogui
else
   $@
fi

