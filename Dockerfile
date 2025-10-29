FROM hihqlink/php-swoole-cli:8.3

WORKDIR /var/www

COPY . /var/www

RUN composer install --no-dev --optimize-autoloader