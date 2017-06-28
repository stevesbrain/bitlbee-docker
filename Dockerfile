FROM alpine:3.6
MAINTAINER Stevesbrain
# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="stevesbrain version:- ${VERSION} Build-date:- ${BUILD_DATE}"
ARG CONFIGUREFLAGS="--config=/bitlbee-data"
#ARG MAKEFLAGS="-j"

ENV BITLBEE_VERSION 3.5.1

# Build Bitlbee
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
    && mkdir /bitlbee-src && cd /bitlbee-src \
    && curl -fsSL "http://get.bitlbee.org/src/bitlbee-${BITLBEE_VERSION}.tar.gz" -o bitlbee.tar.gz \
    && tar -zxf bitlbee.tar.gz --strip-components=1 \
    && PYTHONDONTWRITEBYTECODE=yes \
    && mkdir /bitlbee-data \
    && ./configure ${CONFIGUREFLAGS} \
    && make \
    && make install \
    && make install-dev \
    && make install-etc \
    && apk del --purge build-dependencies \
    && rm -rf /bitlbee-src; exit 0

# Build Facebook
WORKDIR /root
RUN set -x \
	&& git clone https://github.com/jgeboski/bitlbee-facebook.git \
	&& cd bitlbee-facebook \
	&& ./autogen.sh \
	&& make \
	&& make install \
	&& rm -rf  /root/bitlbee-facebook \
	&& apk del --purge autoconf automake \
	&& rm -rf /src; exit 0

# Add our users for ZNC
RUN adduser -u 1000 -S bitlbee
RUN addgroup -g 1000 -S bitlbee

#Make the ZNC Data dir
#RUN mkdir /znc-data

#Copy the necessary files
#WORKDIR /
COPY docker-entrypoint.sh /
#COPY znc.conf.example /docker

#Change ownership as needed
RUN chown -R bitlbee:bitlbee /bitlbee-data
#RUN chown -R znc:znc /docker

#The user that we enter the container as, and that everything runs as
USER bitlbee
VOLUME /bitlbee-data
ENV BUILD 0.3.0
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-D", "-n", "-d", "/bitlbee-data"]
#CMD ["-D -n -d /bitlbee-data"]
