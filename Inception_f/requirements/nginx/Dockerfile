
# Use Debian 11 (Bullseye) - penultimate stable version
FROM debian:11

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL directory
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Copy NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/sites-available/default

# Copy SSL certificate generation script
COPY conf/generate_ssl.sh /usr/local/bin/generate_ssl.sh
RUN chmod +x /usr/local/bin/generate_ssl.sh

# Copy startup script
COPY conf/start_nginx.sh /usr/local/bin/start_nginx.sh
RUN chmod +x /usr/local/bin/start_nginx.sh

# Create nginx user directories
RUN mkdir -p /var/cache/nginx /var/log/nginx /var/lib/nginx \
    && chown -R www-data:www-data /var/cache/nginx /var/log/nginx /var/lib/nginx \
    && chown -R www-data:www-data /var/www

# Remove default nginx site
RUN rm -f /etc/nginx/sites-enabled/default

# Create symlink for our site
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Expose HTTPS port only
EXPOSE 443

# Use startup script as entrypoint
ENTRYPOINT ["/usr/local/bin/start_nginx.sh"]

# Run NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]