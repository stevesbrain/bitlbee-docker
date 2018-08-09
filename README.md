## BitlBee on Alpine with Plugins
![Docker Pulls](https://img.shields.io/docker/pulls/vanityshed/bitlbee-alpine-plugins.svg)
![Docker Stars](https://img.shields.io/docker/stars/vanityshed/bitlbee-alpine-plugins.svg)

Minimal build of latest BitlBee on latest Alpine with latest plugins for:
* [Bonjour](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple-bonjour)
* [Discord](https://github.com/sm00th/bitlbee-discord)
* [Facebook](https://github.com/jgeboski/bitlbee-facebook)
* [ICQ](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple-oscar)
* [Skype](https://github.com/EionRobb/skype4pidgin)
* [Slack](https://github.com/dylex/slack-libpurple)
* [Steam](https://github.com/bitlbee/bitlbee-steam)
* [Telegram](https://github.com/majn/telegram-purple)
* [XMPP (Jabber)](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple-xmpp)

## Typical Usage

For configuration persistance, `/opt/dockerdata/bitlbee` should be present on the host with sufficient permissions.

##### Using Docker CLI
```
docker run -d --name bitlbee --restart=always \
-v /opt/dockerdata/bitlbee:/bitlbee-data:rw \
-v /etc/localtime:/etc/localtime:ro \
-p 6667:6667 \
vanityshed/bitlbee-alpine-plugins
```

##### Using Docker Compose
```
docker-compose up -d
```
