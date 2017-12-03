FROM centos:7

MAINTAINER James Eckersall <james.eckersall@gmail.com>

COPY plex.repo /etc/yum.repos.d/

RUN \
  yum -y install plexmediaserver && \
  mkdir -p --mode 0755 /Library /media/films /media/music /media/photos /media/tv /media/videos

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
