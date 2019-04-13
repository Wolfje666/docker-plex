FROM debian:latest

MAINTAINER James Eckersall <james.eckersall@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# TODO: Parse version number to aid release tag
# https://plex.tv/api/downloads/1.json | jq '.computer.Linux.releases[] |select(.distro=="ubuntu" and .build=="linux-ubuntu-x86_64")'
# {
#   "label": "Ubuntu 64-bit (10.04 Lucid or newer)",
#   "build": "linux-ubuntu-x86_64",
#   "distro": "ubuntu",
#   "url": "https://downloads.plex.tv/plex-media-server/1.12.1.4885-1046ba85f/plexmediaserver_1.12.1.4885-1046ba85f_amd64.deb",
#   "checksum": "d83c93362ad4b5525716440c97ef1f290fe2752b"
# }

# curl -s https://plex.tv/api/downloads/1.json | jq '.computer.Linux.releases[] |select(.distro=="ubuntu" and .build=="linux-ubuntu-x86_64") .url' | cut -d\/ -f5
# 1.12.1.4885-1046ba85f
ARG PLEX_VERSION=1.15.3.876-ad6e39743
ARG PLEX_URL=https://downloads.plex.tv/plex-media-server-new/1.15.3.876-ad6e39743/debian/plexmediaserver_1.15.3.876-ad6e39743_amd64.deb

# wget -q "https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu" -O /tmp/plex.deb && \
RUN \
  apt-get update && \
  apt-get install -y wget && \
  wget -q "${PLEX_URL}" -O /tmp/plex.deb && \
  dpkg --install /tmp/plex.deb && \
  rm -f /tmp/plex.deb && \
  apt-get -fy install && \
  mkdir -p --mode 0775 /Library /media/films /media/music /media/photos /media/tv /media/videos && \
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY start.sh /

ENV \
  PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6 \
  PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver \
  PLEX_MEDIA_SERVER_MAX_STACK_SIZE=3000 \
  PLEX_MEDIA_SERVER_TMPDIR=/tmp

VOLUME /Library /media/films /media/music /media/photos /media/tv /media/videos

EXPOSE 1900/udp 3005/tcp 8324/tcp 32400/tcp 32410/udp 32412/udp 32413/udp 32414/udp 32469/tcp

ENTRYPOINT ["/bin/bash", "/start.sh"]
CMD ["run"]
