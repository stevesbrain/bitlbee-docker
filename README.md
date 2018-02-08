## BitlBee on Alpine with Plugins
![Docker Pulls](https://img.shields.io/docker/pulls/vanityshed/bitlbee-alpine-plugins.svg)
![Docker Stars](https://img.shields.io/docker/stars/vanityshed/bitlbee-alpine-plugins.svg)

Minimal build of latest BitlBee on latest Alpine with latest plugins for:
* [Discord](https://github.com/sm00th/bitlbee-discord)
* [Facebook](https://github.com/jgeboski/bitlbee-facebook)
* [Skype](https://github.com/EionRobb/skype4pidgin)
* [Telegram](https://github.com/majn/telegram-purple)

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
docker-compose -d up
```
