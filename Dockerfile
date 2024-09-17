FROM alpine:3.20

ARG RELEASE

RUN apk add --no-cache --virtual .build-deps git build-base linux-headers \
    && mkdir -p /usr/src/3proxy \
    && git clone https://github.com/3proxy/3proxy.git /usr/src/3proxy \
    && if [[ -z "${RELEASE}" ]]; then \
        RELEASE=$(git -C /usr/src/3proxy describe --tags \
                $(git -C /usr/src/3proxy rev-list --tags --max-count=1)); fi \
    && git -C /usr/src/3proxy checkout tags/$RELEASE \
    && make -C /usr/src/3proxy -f Makefile.Linux \
    && make -C /usr/src/3proxy -f Makefile.Linux install \
    && mv /usr/local/3proxy/conf/add3proxyuser.sh /usr/local/bin/add3proxyuser.sh \
    && chmod +x /usr/local/bin/add3proxyuser.sh \
    && rm -r /usr/src/3proxy \
    && rm /etc/3proxy/3proxy.cfg \
    && apk del .build-deps

COPY ./3proxy.cfg /usr/local/3proxy/conf/.
COPY ./docker-entrypoint.sh /.

ARG BUILD_DATE="1970-01-01T00:00:00Z"

LABEL org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.authors="Danil Ibragimov" \
      org.opencontainers.image.ref.name="difeid/3proxy" \
      org.opencontainers.image.title="3proxy server"

ENV USER=3proxy
ENV PASS=3proxy

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["3proxy_run"]
