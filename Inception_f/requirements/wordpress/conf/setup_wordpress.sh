#!/bin/bash

set -e

echo "Starting WordPress setup..."

# Wait for MariaDB to be ready
echo "Waiting for database connection..."
while ! mysqladmin ping -h"$WP_DB_HOST" --silent; do
    sleep 1
done
echo "Database is ready!"

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Installing WordPress..."

    # Download WordPress core
    wp core download --allow-root

    # Create wp-config.php
    wp core config \
        --dbname="$WP_DB_NAME" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASSWORD" \
        --dbhost="$WP_DB_HOST" \
        --allow-root

    # Install WordPress
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Create additional user
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root

    echo "WordPress installation completed!"

    # Set proper permissions
    chown -R www-data:www-data /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;

else
    echo "WordPress already installed, skipping setup..."
fi

echo "Starting PHP-FPM..."

# Execute the command passed to docker run
exec "$@"