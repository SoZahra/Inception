# Use Debian 11 (Bullseye) - penultimate stable version
FROM debian:11

# Install PHP, Apache, and dependencies for Adminer
RUN apt-get update && apt-get install -y \
    apache2 \
    php7.4 \
    php7.4-mysql \
    php7.4-mysqli \
    php7.4-pgsql \
    php7.4-sqlite3 \
    libapache2-mod-php7.4 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download Adminer
RUN wget -O /var/www/html/index.php https://www.adminer.org/latest.php
RUN rm -f /var/www/html/index.html

# Copy Apache configuration
COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy Adminer startup script
COPY conf/start_adminer.sh /usr/local/bin/start_adminer.sh
RUN chmod +x /usr/local/bin/start_adminer.sh

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod 644 /var/www/html/index.php

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod php7.4

# Expose port 8080
EXPOSE 8080

# Use startup script as entrypoint
ENTRYPOINT ["/usr/local/bin/start_adminer.sh"]

# Run Apache in foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
