
# Use Debian 11 (Bullseye) - penultimate stable version
FROM debian:11

# Install Nginx
RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Remove default nginx content
RUN rm -rf /var/www/html/*

# Copy static website files
COPY conf/index.html /var/www/html/index.html
COPY conf/style.css /var/www/html/style.css
COPY conf/script.js /var/www/html/script.js

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create nginx directories
RUN mkdir -p /var/log/nginx /var/lib/nginx \
    && chown -R www-data:www-data /var/log/nginx /var/lib/nginx

# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]