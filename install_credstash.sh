#!/bin/sh
# vim: et smartindent sr sw=4 ts=4:
echo "$0: installing python, pip and credstash"                              \
&& apk --no-cache add wget curl python python-dev less                       \
&& wget -q -T 10 -O /var/tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py \
&& python /var/tmp/get-pip.py                                                \
&& pip --no-cache-dir install --upgrade credstash                            \
&& apk --purge del wget                                                      \
&& rm /var/tmp/get-pip.py                                                    \
&& credstash -h                                                              #
