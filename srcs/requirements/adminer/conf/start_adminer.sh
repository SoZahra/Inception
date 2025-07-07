#!/bin/bash
echo "Starting Adminer..."

# Configure Apache to listen on port 8080
echo "Listen 8080" >> /etc/apache2/ports.conf

# Start Apache
echo "Apache configured for Adminer access!"
exec "$@"
