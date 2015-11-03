# Debian based linux. openjdk-7-jre-headless
FROM java:7-jre
MAINTAINER kitsunedo13@gmail.com

# Minecraft Server Version and Docker Container Image Build Number
LABEL version="1.8.8-1"

# DATA Directory
ENV DATA_DIR /opt/minecraft
VOLUME ["/opt/minecraft"]

# copy entrypoint script and create restricted user
ADD assets /usr/local/sbin/
RUN useradd minecraft
RUN chmod +x /usr/local/sbin/entrypoint.sh

# Minecraft Server's default port number
EXPOSE 25565

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]


