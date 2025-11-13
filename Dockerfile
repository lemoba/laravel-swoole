# FROM registry.cn-shanghai.aliyuncs.com/ranen1024/php-fpm-nginx:php83-v1.0-alpine
FROM registry.cn-shanghai.aliyuncs.com/ranen1024/php-cli-alpine:8.3-v1

WORKDIR /var/www/html

COPY --chown=www-data:www-data . .

RUN ./vendor/bin/rr get-binary

RUN chmod +x ./vendor/bin/rr