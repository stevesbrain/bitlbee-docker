FROM alpine:latest as builder
LABEL maintainer=stevesbrain,realies

ENV BITLBEE_COMMIT 246b98b
ENV DISCORD_COMMIT 020fe0f
ENV FACEBOOK_COMMIT 553593d
ENV SKYPE_COMMIT c395028
ENV SLACK_COMMIT b0f1550
ENV STEAM_COMMIT a6444d2
ENV TELEGRAM_COMMIT 94dd3be

RUN set -x \
	&& apk update \
	&& apk upgrade \
	&& apk add --virtual build-dependencies \
	autoconf \
	gnutls-dev \
	pidgin-dev \
	libgcrypt-dev \
	libwebp-dev \
	automake \
	build-base \
	curl \
	git \
	json-glib-dev \
	libtool
RUN cd /root \
	&& git clone -n https://github.com/bitlbee/bitlbee \
	&& cd bitlbee \
	&& git checkout ${BITLBEE_COMMIT} \
	&& mkdir /bitlbee-data \
	&& ./configure --purple=1 --config=/bitlbee-data \
	&& make \
	&& cp bitlbee / \
	&& make install \
	&& make install-dev \
	&& make install-etc

FROM builder as facebook-builder
RUN cd /root \
	&& git clone -n https://github.com/jgeboski/bitlbee-facebook \
	&& cd bitlbee-facebook \
	&& git checkout ${FACEBOOK_COMMIT} \
	&& ./autogen.sh \
	&& make \
	&& make install

FROM builder as discord-builder
RUN cd /root \
	&& git clone -n https://github.com/sm00th/bitlbee-discord \
	&& cd bitlbee-discord \
	&& git checkout ${DISCORD_COMMIT} \
	&& ./autogen.sh \
	&& ./configure \
	&& make \
	&& make install

FROM builder as skype-builder
RUN cd /root \
	&& git clone -n https://github.com/EionRobb/skype4pidgin \
	&& cd skype4pidgin \
	&& git checkout ${SKYPE_COMMIT} \
	&& cd skypeweb \
	&& make \
	&& make install

FROM builder as slack-builder
RUN cd /root \
	&& git clone -n https://github.com/dylex/slack-libpurple \
	&& cd slack-libpurple \
	&& git checkout ${SLACK_COMMIT} \
	&& make \
	&& mkdir -p /usr/share/pixmaps/pidgin/protocols/16/ \
	&& mkdir -p /usr/share/pixmaps/pidgin/protocols/22/ \
	&& mkdir -p /usr/share/pixmaps/pidgin/protocols/48/ \
	&& make install

FROM builder as steam-builder
RUN cd /root \
	&& git clone -n https://github.com/bitlbee/bitlbee-steam \
	&& cd bitlbee-steam \
	&& git checkout ${STEAM_COMMIT} \
	&& ./autogen.sh \
	&& make \
	&& make install

FROM builder as telegram-builder
RUN cd /root \
	&& git clone -n https://github.com/majn/telegram-purple \
	&& cd telegram-purple \
	&& git checkout ${TELEGRAM_COMMIT} \
	&& git submodule update --init --recursive \
	&& ./configure \
	&& make \
	&& make install

FROM alpine:latest
LABEL maintainer=stevesbrain,realies

RUN apk update
RUN apk upgrade
RUN apk add glib \
	gnutls \
	json-glib \
	libgcrypt \
	libpurple \
	libwebp \
	pidgin \
	&& adduser -u 1000 -S bitlbee \
	&& addgroup -g 1000 -S bitlbee \
	&& mkdir /bitlbee-data \
	&& chown -R bitlbee:bitlbee /bitlbee-data \
	&& touch /var/run/bitlbee.pid \
	&& chown bitlbee:bitlbee /var/run/bitlbee.pid

COPY --from=facebook-builder /usr/local/lib/bitlbee/facebook.* /usr/local/lib/bitlbee/

COPY --from=discord-builder /usr/local/lib/bitlbee/discord.* /usr/local/lib/bitlbee/
COPY --from=discord-builder /usr/local/share/bitlbee/discord-help.txt /usr/local/share/bitlbee/discord-help.txt

COPY --from=skype-builder /usr/lib/purple-2/libskypeweb.so /usr/lib/purple-2/libskypeweb.so
COPY --from=skype-builder /usr/share/pixmaps/pidgin/emotes/skype/theme /usr/share/pixmaps/pidgin/emotes/skype/theme
# COPY --from=skype-builder /usr/share/pixmaps/pidgin/protocols/16/skype* /usr/share/pixmaps/pidgin/protocols/16/
# COPY --from=skype-builder /usr/share/pixmaps/pidgin/protocols/22/skype* /usr/share/pixmaps/pidgin/protocols/22/
# COPY --from=skype-builder /usr/share/pixmaps/pidgin/protocols/48/skype* /usr/share/pixmaps/pidgin/protocols/48/

COPY --from=slack-builder /usr/lib/purple-2/libslack.so /usr/lib/purple-2/libslack.so
# COPY --from=slack-builder /usr/share/pixmaps/pidgin/protocols/16/slack.png /usr/share/pixmaps/pidgin/protocols/16/slack.png
# COPY --from=slack-builder /usr/share/pixmaps/pidgin/protocols/22/slack.png /usr/share/pixmaps/pidgin/protocols/22/slack.png
# COPY --from=slack-builder /usr/share/pixmaps/pidgin/protocols/48/slack.png /usr/share/pixmaps/pidgin/protocols/48/slack.png

COPY --from=steam-builder /usr/local/lib/bitlbee/steam.* /usr/local/lib/bitlbee/

COPY --from=telegram-builder /etc/telegram-purple/server.tglpub /etc/telegram-purple/server.tglpub
COPY --from=telegram-builder /usr/lib/purple-2/telegram-purple.so /usr/lib/purple-2/telegram-purple.so

COPY --from=builder /usr/local/etc/bitlbee/ /usr/local/etc/bitlbee/
COPY --from=builder /usr/local/include/bitlbee/ /usr/local/include/bitlbee/
COPY --from=builder /usr/local/lib/pkgconfig/bitlbee.pc /usr/local/lib/pkgconfig/bitlbee.pc
COPY --from=builder /usr/local/sbin/bitlbee /usr/local/sbin/bitlbee
COPY --from=builder /usr/local/share/bitlbee/help.txt /usr/local/share/bitlbee/help.txt

USER bitlbee
VOLUME /bitlbee-data
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
