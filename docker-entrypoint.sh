#!/bin/sh

set -e

# configure user
if ! [[ -s /usr/local/etc/3proxy/passwd ]]; then
    echo -e "${USER}:CL:${PASS}" > /usr/local/etc/3proxy/passwd
    echo -e "3proxy user: \t${USER}\n3proxy pass: \t${PASS}"
fi


if [ "$1" = "3proxy_run" ]; then
    exec "/usr/local/bin/3proxy" "/usr/local/etc/3proxy/3proxy.cfg"
else
    exec "$@"
fi
