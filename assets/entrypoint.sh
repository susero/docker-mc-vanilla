#!/bin/bash

HOME_DIR=/opt/minecraft
DATA_DIR=${HOME_DIR}/data
TMP_DIR=${HOME_DIR}/tmp

# PARAMS
AGREE_TO_EULA=${AGREE_TO_EULA:-false}
JVM_MX=${JVM_MX:-2G}
JVM_MS=${JVM_MS:-1024M}
SYSTEM_TIMEZONE=${SYSTEM_TIMEZONE:-Asia/Tokyo}

# SETUP SYSTEM TIMEZONE
if [ ! -e /usr/share/zoneinfo/${SYTEM_TIMEZONE} ]; then
   echo "Invalid timezone name or broken system."
   exit 1
fi
echo "${SYSTEM_TIMEZONE}" > /etc/timezone
cp /usr/share/zoneinfo/${SYSTEM_TIMEZONE} /etc/localtime

[ -e ${HOME_DIR} ] || mkdir -p ${HOME_DIR}
[ -e ${DATA_DIR} ] || mkdir -p ${DATA_DIR}
[ -e ${TMP_DIR} ] || mkdir -p ${TMP_DIR}

[ -d ${DATA_DIR}/world ] || mkdir -p ${DATA_DIR}/world

cd ${DATA_DIR}

if [ ! -e eula.txt ]; then
cat > eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sat Jun 13 13:22:23 UTC 2015
eula=${AGREE_TO_EULA}
EOF
#else
#   sed -i -e 's/eula=.*/eula=${AGREE_TO_EULA}/' eula.txt
fi

if [ $# -eq 0 ]; then
   sudo -u minecraft java -Xms${JVM_MS} -Xmx${JVM_MX} -d64 -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -jar /usr/local/sbin/lib/server/minecraft_server.1.8.8.jar nogui
else
   $@
fi

