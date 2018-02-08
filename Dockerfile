FROM alpine:latest
LABEL maintainer=stevesbrain

ENV BITLBEE_COMMIT 4a9c6b0
ENV FACEBOOK_COMMIT 553593d
ENV DISCORD_COMMIT 0a84f9d
ENV TELEGRAM_COMMIT 94dd3be
ENV SKYPE_COMMIT c442007

RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --virtual build-dependencies \
	autoconf \
	automake \
	build-base \
	curl \
	git \
	json-glib-dev \
	libtool \
    && apk add --virtual runtime-dependencies \
	glib-dev \
	gnutls-dev \
	json-glib \
	libgcrypt-dev \
	libpurple \
	libwebp-dev \
	pidgin-dev \
    && cd /root \
    && git clone -n https://github.com/bitlbee/bitlbee \
    && cd bitlbee \
    && git checkout ${BITLBEE_COMMIT} \
    && mkdir /bitlbee-data \
    && ./configure --purple=1 --config=/bitlbee-data \
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
    && rm -rf /var/cache/apk/* \
    && adduser -u 1000 -S bitlbee \
    && addgroup -g 1000 -S bitlbee \
    && chown -R bitlbee:bitlbee /bitlbee-data \
    && touch /var/run/bitlbee.pid \
    && chown bitlbee:bitlbee /var/run/bitlbee.pid; exit 0

USER bitlbee
VOLUME /bitlbee-data
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
