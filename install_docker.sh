#!/bin/sh
# vim: et smartindent sr sw=4 ts=4:
REPO_URI="http://alpine.gliderlabs.com/alpine/v3.3/community"
COMPATIBLE_DOCKER_VERSION=1.9.1-r2
URI_ESC="$(echo "$REPO_URI" | sed -e 's/\//\\\//g')"
REPO_FILE=/etc/apk/repositories
ID_ON_COREOS=233
echo "$0: installing docker compatible with coreos"
echo "$0: precreating group and user to match coreos (233)"

addgroup -g $ID_ON_COREOS docker
adduser -D -H -u $ID_ON_COREOS -G docker docker

echo "$0 ... hacking repo list for suitable version"
echo "$REPO_URI" >>$REPO_FILE
if apk --no-cache --update add docker=$COMPATIBLE_DOCKER_VERSION
then
    echo "$0 ... installed - removing $REPO_URI from repo list"
    sed -i "/$URI_ESC/d" $REPO_FILE || exit 1
else
    echo "$0 ... install failure"
    exit 1
fi

echo "$0: adding core and root to docker group"
addgroup core docker
addgroup root docker
