#!/bin/sh

set -e

# configure user
if ! [ -s /usr/local/3proxy/conf/passwd ]; then
    /usr/local/bin/add3proxyuser.sh ${USER} ${PASS}
    echo -e "3proxy user: \t${USER}\n3proxy pass: \t${PASS}"
fi


if [ "$1" = "3proxy_run" ]; then
    exec "/bin/3proxy" "/usr/local/3proxy/conf/3proxy.cfg"
else
    exec "$@"
fi
