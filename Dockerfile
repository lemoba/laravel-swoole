FROM serversideup/php:8.3-cli-alpine as base

USER root

RUN install-php-extensions bcmath swoole

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

USER www-data

CMD ["/usr/local/bin/start.sh"]
