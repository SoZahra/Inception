FROM debian:11

RUN apt-get update && apt-get install -y \
 php7.4-fpm \
 php7.4-mysql \
 php7.4-curl \
 php7.4-gd \
 php7.4-intl \
 php7.4-mbstring \
 php7.4-soap \
 php7.4-xml \
 php7.4-xmlrpc \
 php7.4-zip \
 wget \
 curl \
 mariadb-client \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html \
 && chown -R www-data:www-data /var/www/html

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp

COPY conf/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN chmod +x /usr/local/bin/setup_wordpress.sh

RUN mkdir -p /run/php \
 && chown www-data:www-data /run/php

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN chmod 644 /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]
CMD ["php-fpm7.4", "-F"]
