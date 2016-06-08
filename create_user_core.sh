#!/bin/sh
# vim: ts=4 sw=4 sr et smartindent:
# create_user_core.sh
# - suitable for alpine
# - uses uid, gid 500 from coreos
###################################################
# WARNING - the intention here is to let core user
# run root-level commands inside the container, but
# the setuid hack would let any container user run
# as superuser.
###################################################
apk --no-cache add su-exec bash \
&& addgroup -g 500 core     \
&& adduser -D -h /home/core \
           -s /bin/bash     \
           -u 500 -G core   \
           core             \
&& chmod u+s /sbin/su-exec \
&& rm /var/cache/apk/*

# ... verify
if ! su - -c "/sbin/su-exec root ls -a /root" core
then
    echo "$0 ERROR: couldn't install su-exec properly."
    exit 1
fi

