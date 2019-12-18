FROM wordpress:fpm

RUN pecl install xdebug

RUN docker-php-ext-enable xdebug

RUN XDEBUG=$(find /usr/local/lib/php -name 'xdebug.so' | head -n 1 | tail -n 1) \
	&& ln -s $XDEBUG /usr/local/lib/php/extensions/xdebug.so

RUN apt-get update
RUN apt-get install iproute2 -y

COPY entrypoint.sh /custom-entrypoint.sh

RUN chmod +x /custom-entrypoint.sh