#!/bin/sh
# vim: et smartindent sr sw=4 ts=4:
REPO_URI="http://alpine.gliderlabs.com/alpine/v3.3/community"
URI_ESC="$(echo "$REPO_URI" | sed -e 's/\//\\\//g')"
REPO_FILE=/etc/apk/repositories
echo "$0: installing docker compatible with coreos"
echo "$0 ... hacking repo list for suitable version"
echo "$REPO_URI" >>$REPO_FILE
if apk --no-cache --update add docker
then
    echo "$0 ... installed - removing $REPO_URI from repo list"
    sed -i "/$URI_ESC/d" $REPO_FILE
else
    echo "$0 ... install failure"
    exit 1
fi

echo "$0: adding core and root to docker group"
addgroup core docker
addgroup root docker
