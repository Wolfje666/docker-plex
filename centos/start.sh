#!/bin/bash

export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/Library/Application Support"
export LD_LIBRARY_PATH="${PLEX_MEDIA_SERVER_HOME}"
export TMPDIR="${PLEX_MEDIA_SERVER_TMPDIR}"

if [ -f /etc/default/locale ]; then
  export LANG="`cat /etc/default/locale|awk -F '=' '/LANG=/{print $2}'|sed 's/"//g'`"
  export LC_ALL="$LANG"
fi

if [ ! -d "$PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR" ]
then
  mkdir -p "$PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR"
  if [ ! $? -eq 0 ]
  then
    echo "WARNING COULDN'T CREATE $PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR, MAKE SURE I HAVE PERMISSON TO DO THAT!"
    exit 1
  fi
fi

export LD_LIBRARY_PATH="${PLEX_MEDIA_SERVER_HOME}"
export TMPDIR="${PLEX_MEDIA_SERVER_TMPDIR}"

#echo $PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS $PLEX_MEDIA_SERVER_MAX_STACK_SIZE $PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR

ulimit -s $PLEX_MEDIA_SERVER_MAX_STACK_SIZE

if [ "$1" == "run" ]; then
  cd /usr/lib/plexmediaserver && exec ./Plex\ Media\ Server
else
  exec "$@"
fi
