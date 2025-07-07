#!/bin/bash

set -e

echo "Starting NGINX setup..."

# Generate SSL certificates if they don't exist
/usr/local/bin/generate_ssl.sh

# Test NGINX configuration
echo "Testing NGINX configuration..."
nginx -t

echo "NGINX configuration is valid!"

# Wait for WordPress to be ready
echo "Waiting for WordPress to be ready..."
sleep 10
echo "WordPress should be ready!"

echo "Starting NGINX..."

# Execute the command passed to docker run
exec "$@"