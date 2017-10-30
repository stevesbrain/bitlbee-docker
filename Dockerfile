FROM alpine:3.6
MAINTAINER Stevesbrain
ARG BUILD_DATE
ARG VERSION
LABEL build_version="stevesbrain version:- ${VERSION} Build-date:- ${BUILD_DATE}"
ARG CONFIGUREFLAGS="--purple=1 --config=/bitlbee-data"

ENV BITLBEE_VERSION 3.5.1
ENV FACEBOOK_COMMIT 553593d
ENV DISCORD_COMMIT 18bcf33
ENV TELEGRAM_COMMIT 94dd3be

# Build Bitlbee and plugins
RUN set -x \
    && apk add --no-cache --virtual runtime-dependencies \
        ca-certificates \
	gnutls-dev \
	git \
        build-base \
        curl \
	glib-dev \
	libgcrypt-dev \
	autoconf \
	automake \
	libtool \
	json-glib \
	json-glib-dev \
	file \
	libpurple \
	pidgin-dev \
	libwebp-dev \
    && mkdir /bitlbee-src && cd /bitlbee-src \
    && curl -fsSL "http://get.bitlbee.org/src/bitlbee-${BITLBEE_VERSION}.tar.gz" -o bitlbee.tar.gz \
    && tar -zxf bitlbee.tar.gz --strip-components=1 \
    && mkdir /bitlbee-data \
    && ./configure ${CONFIGUREFLAGS} \
    && make \
    && make install \
    && make install-dev \
    && make install-etc \
    && cd /root \
    && git clone https://github.com/jgeboski/bitlbee-facebook.git \
    && cd bitlbee-facebook \
    && ./autogen.sh \
    && make \
    && make install \
    && cd /root \
    && git clone https://github.com/sm00th/bitlbee-discord \
    && cd /root/bitlbee-discord \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install
RUN set -x \
    && cd /root \
    && git clone --recursive https://github.com/majn/telegram-purple
RUN set -x \
    && cd /root/telegram-purple \
    && apk add --no-cache --virtual finch \
    && ./configure \
    && make \
    && make install \
    && apk del --purge build-dependencies \
	autoconf \
	automake \
	libtool \
	json-glib \
	json-glib-dev \
	libgcrypt-dev \
	glib-dev \
	gnutls-dev \
	file \
	pidgin-dev \
	libwebp-dev \
    && rm -rf /bitlbee-src \
    && rm -rf /root/bitlbee-facebook \
    && rm -rf /root/bitlbee-discord \
    && rm -rf /root/telegram-purple \
    && rm -rf /src; exit 0


# Add our users for ZNC
RUN adduser -u 1000 -S bitlbee
RUN addgroup -g 1000 -S bitlbee


#Change ownership as needed
RUN chown -R bitlbee:bitlbee /bitlbee-data
RUN touch /var/run/bitlbee.pid && chown bitlbee:bitlbee /var/run/bitlbee.pid
#The user that we enter the container as, and that everything runs as
USER bitlbee
VOLUME /bitlbee-data
ENV BUILD 0.3.0
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
