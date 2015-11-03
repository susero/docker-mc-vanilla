FROM ubuntu:14.04

#
# http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
#
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
 && echo debconf shared/accepted-oracle-license-v1-1 select true | \
    debconf-set-selections \
 && echo debconf shared/accepted-oracle-license-v1-1 seen true | \
    debconf-set-selections \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
 && apt-get update \
 && apt-get install -y oracle-java7-installer 

ADD assets/setup /app/setup/
RUN chmod +x /app/setup/install
RUN /app/setup/install

ADD assets/init /app/init
RUN chmod +x /app/init

VOLUME /opt/minecraft/data
EXPOSE 25565

CMD /app/init


