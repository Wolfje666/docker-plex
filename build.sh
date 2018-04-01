#!/bin/sh

URL=$(curl -s https://plex.tv/api/downloads/1.json | jq '.computer.Linux.releases[] |select(.distro=="ubuntu" and .build=="linux-ubuntu-x86_64") .url' | sed -e 's/"//g')
VERSION=$(echo $URL | cut -d\/ -f5)

echo "URL: ${URL}"
echo "Version: ${VERSION}"

echo "Found online version: ${VERSION}"

DOCKERFILE_VERSION=$(grep "^ARG PLEX_VERSION=" Dockerfile | cut -f2 -d\=)

echo "Dockerfile version: ${DOCKERFILE_VERSION}"

if [ "${VERSION}" != "${DOCKERFILE_VERSION}" ]; then
  echo "Updating Dockerfile with version ${VERSION}"
  sed -i -e "s/^\(ARG PLEX_VERSION=\).*$/\1${VERSION}/g" \
         -e "s|^\(ARG PLEX_URL=\).*$|\1${URL}|g" Dockerfile
  git add Dockerfile
  git commit -m "Bumping Plex version to ${VERSION}"
  git push
  make minor-release
else
  echo "No change"
fi
