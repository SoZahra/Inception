#!/bin/bash
set -e

echo "Starting WordPress setup..."

echo "Waiting for database connection..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done
echo "Database is ready!"

# Supprimer temporairement l'attente Redis
# echo "Waiting for Redis connection..."
# while ! redis-cli -h redis -p 6379 -a "$REDIS_PASSWORD" ping > /dev/null 2>&1; do
#     echo "Waiting for Redis..."
#     sleep 1
# done
# echo "Redis is ready!"

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Installing WordPress..."
    
    if [ ! -f "/var/www/html/wp-includes/version.php" ]; then
        wp core download --allow-root
    else
        echo "WordPress files already present, skipping download..."
    fi
    
    wp core config --dbname="$WP_DB_NAME" --dbuser="$WP_DB_USER" --dbpass="$WP_DB_PASSWORD" --dbhost="mariadb" --allow-root
    
    if ! wp core is-installed --allow-root 2>/dev/null; then
        wp core install \
            --url="https://$DOMAIN_NAME" \
            --title="$WP_TITLE" \
            --admin_user="$WP_ADMIN_USER" \
            --admin_password="$WP_ADMIN_PASSWORD" \
            --admin_email="$WP_ADMIN_EMAIL" \
            --skip-email \
            --allow-root
        
        wp user create "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --role=author --allow-root
        wp user create "$WP_USER2" "$WP_USER2_EMAIL" --user_pass="$WP_USER2_PASSWORD" --role=editor --allow-root

        echo "Configuring WordPress..."
        wp option update blogdescription "Inception WordPress Project" --allow-root
        wp option update default_comment_status "open" --allow-root
        wp option update thread_comments "1" --allow-root
        wp option update comment_moderation "0" --allow-root
        
        # Create content
        wp post create \
            --post_title="Welcome to Inception" \
            --post_content="<h2>Inception WordPress</h2><p>Docker infrastructure with NGINX, WordPress, MariaDB, Redis cache, Adminer, FTP, and automated backups.</p>" \
            --post_status=publish \
            --allow-root
        
        # Install WP Force Login
        wp plugin install wp-force-login --activate --allow-root
        
        echo "WordPress setup completed!"
    fi
    
    chown -R www-data:www-data /var/www/html
else
    echo "WordPress already installed, skipping setup..."
fi

echo "Starting PHP-FPM..."
exec "$@"
