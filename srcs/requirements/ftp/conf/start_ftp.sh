#!/bin/bash
set -e

echo "Starting FTP Server..."

# Create FTP user if not exists
if ! id "$FTP_USER" &>/dev/null; then
    echo "Creating FTP user: $FTP_USER"
    useradd -d "$FTP_ROOT" -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    
    # Ensure user owns the WordPress directory
    chown -R "$FTP_USER:$FTP_USER" "$FTP_ROOT"
else
    echo "FTP user $FTP_USER already exists"
fi

# Create necessary directories
mkdir -p /var/run/vsftpd/empty
mkdir -p /var/log/vsftpd

# Set permissions
chmod 755 "$FTP_ROOT"
chown root:root /var/run/vsftpd/empty

echo "FTP Configuration:"
echo "- User: $FTP_USER"
echo "- Root directory: $FTP_ROOT"
echo "- Port: 21"
echo "- Passive ports: 21000-21010"
echo "- WordPress files accessible via FTP!"

echo "Starting vsftpd..."
exec "$@"
