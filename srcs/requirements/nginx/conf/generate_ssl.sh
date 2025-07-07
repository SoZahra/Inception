#!/bin/bash

set -e

CERT_PATH="/etc/ssl/certs/inception.crt"
KEY_PATH="/etc/ssl/private/inception.key"

# Check if certificates already exist
if [ -f "$CERT_PATH" ] && [ -f "$KEY_PATH" ]; then
    echo "SSL certificates already exist, skipping generation..."
    exit 0
fi

echo "Generating SSL certificate for $DOMAIN_NAME..."

# Generate private key
openssl genrsa -out "$KEY_PATH" 2048

# Generate certificate signing request
openssl req -new -key "$KEY_PATH" -out /tmp/inception.csr -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42School/OU=Student/CN=$DOMAIN_NAME"

# Generate self-signed certificate
openssl x509 -req -days 365 -in /tmp/inception.csr -signkey "$KEY_PATH" -out "$CERT_PATH"

# Set proper permissions
chmod 600 "$KEY_PATH"
chmod 644 "$CERT_PATH"

# Remove temporary CSR file
rm -f /tmp/inception.csr

echo "SSL certificate generated successfully!"
echo "Certificate: $CERT_PATH"
echo "Private key: $KEY_PATH"