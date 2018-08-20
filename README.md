## BitlBee on Alpine with Plugins
![Docker Pulls](https://img.shields.io/docker/pulls/vanityshed/bitlbee-alpine-plugins.svg)
![Docker Stars](https://img.shields.io/docker/stars/vanityshed/bitlbee-alpine-plugins.svg)

Minimal build of latest BitlBee on latest Alpine with latest plugins for:

| Plugin | Version | Protocol |
|:-------|:--------|:---------|
| [bitlbee-discord](https://github.com/sm00th/bitlbee-discord) | 0.4.1 | discord |
| [bitlbee-steam](https://github.com/bitlbee/bitlbee-steam)          | 1.4.2  | steam |
| [facebook](https://github.com/jgeboski/bitlbee-facebook) | 1.1.2 | facebook |
| [libpurple](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple) | 2.13.0 | gg, irc, novell, simple, zephyr |
| [libpurple-bonjour](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple-bonjour) | 2.13.0 | bonjour |
| [libpurple-oscar](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple-oscar) | 2.13.0 | aim, icq, oscar |
| [libpurple-xmpp](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/libpurple-xmpp) | 2.13.0 | jabber, xmpp | 
| [skype4pidgin](https://github.com/EionRobb/skype4pidgin) | 1.5 | skype |
| [slack-libpurple](https://github.com/dylex/slack-libpurple) | 0.1  | slack |
| [telegram-purple](https://github.com/majn/telegram-purple) | 1.3.1  | telegram |

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
