# ----------------------------------
# Parker testing image
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        openjdk:11-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

## install deps
RUN apt-get update -y \
 && apt-get install -y curl ca-certificates openssl git tar sqlite jq fontconfig tzdata iproute2 \
 && useradd -d /home/container -m container

## install paper into /opt/minecraft
RUN mkdir /opt/minecraft/ \
 && cd /opt/minecraft/ \
 && PAPER_VERSION=`curl -s https://papermc.io/api/v1/paper | jq -r '.versions' | jq -r '.[0]'` \
 && PAPER_BUILD=`curl -s https://papermc.io/api/v1/paper/${PAPER_VERSION} | jq -r '.builds.latest'` \
 && DOWNLOAD_URL=https://papermc.io/api/v1/paper/${PAPER_VERSION}/${PAPER_BUILD}/download \
 && curl -o server.jar ${DOWNLOAD_URL} \
 && mkdir plugins world logs \
 && ln -s $(pwd)/{plugins,logs,world}/ /home/container/

USER container
ENV  USER=container HOME=/home/container

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
