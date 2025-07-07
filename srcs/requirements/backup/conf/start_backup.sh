#!/bin/bash

echo "Starting Inception Backup Service..."

echo "=== BACKUP SERVICE CONFIGURATION ==="
echo "📁 Backup Directory: /backups"
echo "📊 Database Host: mariadb"
echo "🗄️  Database: $MYSQL_DATABASE"
echo "📝 Log File: /var/log/backup/backup.log"
echo "⏰ Schedule: Every 6 hours"
echo "🗑️  Retention: 7 days"

echo ""
echo "=== FEATURES ==="
echo "✅ Automated MariaDB database backup"
echo "✅ Automated WordPress files backup"
echo "✅ Backup compression (gzip/tar.gz)"
echo "✅ Backup integrity verification"
echo "✅ Automatic old backup cleanup"
echo "✅ Detailed logging"
echo "✅ Backup size monitoring"

echo ""
echo "=== BACKUP SCHEDULE ==="
echo "🕐 Every 6 hours: 00:00, 06:00, 12:00, 18:00"
echo "📋 Manual backup: docker exec backup /usr/local/bin/backup.sh"

# Wait for MariaDB to be ready
echo ""
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h mariadb --silent 2>/dev/null; do
    echo "Waiting for database connection..."
    sleep 5
done
echo "✅ Database connection established"

# Perform initial backup
echo ""
echo "Performing initial backup..."
/usr/local/bin/backup.sh

# Apply cron schedule
echo "Setting up automated backup schedule..."
crontab /etc/cron.d/backup-cron

echo ""
echo "=== BACKUP SERVICE READY ==="
echo "View logs: docker logs backup"
echo "Manual backup: docker exec backup /usr/local/bin/backup.sh"
echo "View backup files: docker exec backup ls -la /backups"

# Start cron daemon
exec "$@"
