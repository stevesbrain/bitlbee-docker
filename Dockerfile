FROM alpine:latest
MAINTAINER Stevesbrain
ARG BUILD_DATE
ARG VERSION
LABEL build_version="stevesbrain version:- ${VERSION} Build-date:- ${BUILD_DATE}"
ARG CONFIGUREFLAGS="--purple=1 --config=/bitlbee-data"

ENV BITLBEE_VERSION 3.5.1
ENV FACEBOOK_COMMIT 553593d
ENV DISCORD_COMMIT 0a84f9d
ENV TELEGRAM_COMMIT 94dd3be
ENV SKYPE_COMMIT c442007

# Build BitlBee and plugins
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --virtual build-dependencies \
	curl \
	build-base \
	git \
	autoconf \
	automake \
	libtool \
    && apk add --virtual runtime-dependencies \
	json-glib-dev \
	libgcrypt-dev \
	gnutls-dev \
	glib-dev \
	pidgin-dev \
	libpurple \
	libwebp-dev \
    && mkdir /root/bitlbee-src && cd /root/bitlbee-src \
    && curl -fsSL "http://get.bitlbee.org/src/bitlbee-${BITLBEE_VERSION}.tar.gz" -o bitlbee.tar.gz \
    && tar -zxf bitlbee.tar.gz --strip-components=1 \
    && mkdir /bitlbee-data \
    && ./configure ${CONFIGUREFLAGS} \
    && make \
    && make install \
    && make install-dev \
    && make install-etc \
    && cd /root \
    && git clone -n https://github.com/jgeboski/bitlbee-facebook \
    && cd bitlbee-facebook \
    && git checkout ${FACEBOOK_COMMIT} \
    && ./autogen.sh \
    && make \
    && make install \
    && cd /root \
    && git clone -n https://github.com/sm00th/bitlbee-discord \
    && cd /root/bitlbee-discord \
    && git checkout ${DISCORD_COMMIT} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && cd /root \
    && git clone -n https://github.com/majn/telegram-purple \
    && cd /root/telegram-purple \
    && git checkout ${TELEGRAM_COMMIT} \
    && git submodule update --init --recursive \
    && ./configure \
    && make \
    && make install \
    && cd /root \
    && git clone -n https://github.com/EionRobb/skype4pidgin \
    && cd skype4pidgin \
    && git checkout ${SKYPE_COMMIT} \
    && cd skypeweb \
    && make \
    && make install \
    && apk del --purge build-dependencies \
    && rm -rf /root/* \
    && rm -rf /var/cache/apk/*; exit 0

# Add our users for BitlBee
RUN adduser -u 1000 -S bitlbee
RUN addgroup -g 1000 -S bitlbee

# Change ownership as needed
RUN chown -R bitlbee:bitlbee /bitlbee-data
RUN touch /var/run/bitlbee.pid && chown bitlbee:bitlbee /var/run/bitlbee.pid

# The user that we enter the container as, and that everything runs as
USER bitlbee
VOLUME /bitlbee-data
ENV BUILD 0.3.0
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
