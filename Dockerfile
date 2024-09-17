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
    && rm -r /usr/src/3proxy \
    && apk del .build-deps

COPY ./3proxy.cfg /usr/local/etc/3proxy/.
COPY ./docker-entrypoint.sh /.

LABEL org.opencontainers.image.authors="Danil Ibragimov <email@danil.contact>" \
      org.opencontainers.image.ref.name="dhcp/dhcpv4" \
      org.opencontainers.image.title="3proxy server"

ENV USER=3proxy
ENV PASS=3proxy

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["3proxy_run"]
