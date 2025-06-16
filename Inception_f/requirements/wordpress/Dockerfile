# Use Debian 11 (Bullseye) - penultimate stable version
FROM	debian:11

# Install PHP-FPM, PHP extensions, wget, and other dependencies
RUN	apt-get update && apt-get install -y \
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

# Create www-data user directories
RUN	mkdir -p /var/www/html \
	&& chown -R www-data:www-data /var/www/html

# Download and install WordPress CLI
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM configuration
COPY	conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy WordPress setup script
COPY	conf/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN	chmod +x /usr/local/bin/setup_wordpress.sh

# Create PHP-FPM run directory
RUN	mkdir -p /run/php \
	&& chown www-data:www-data /run/php

# Set working directory
WORKDIR /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Set user to www-data
USER www-data

# Use setup script as entrypoint
ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]

# Run PHP-FPM
CMD ["php-fpm7.4", "-F"]