#!/bin/bash

# Backup script for WordPress and MariaDB
# This script creates automated backups of the Inception infrastructure

LOG_FILE="/var/log/backup/backup.log"
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

log "=== STARTING BACKUP PROCESS ==="

# Create dated backup directory
CURRENT_BACKUP_DIR="$BACKUP_DIR/backup_$DATE"
mkdir -p "$CURRENT_BACKUP_DIR"

log "Backup directory: $CURRENT_BACKUP_DIR"

# 1. Backup MariaDB database
log "Backing up MariaDB database..."
if mysqldump -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" > "$CURRENT_BACKUP_DIR/wordpress_db_$DATE.sql" 2>/dev/null; then
    log "✅ Database backup successful"
    gzip "$CURRENT_BACKUP_DIR/wordpress_db_$DATE.sql"
    log "✅ Database backup compressed"
else
    log "❌ Database backup failed"
fi

# 2. Backup WordPress files
log "Backing up WordPress files..."
if tar -czf "$CURRENT_BACKUP_DIR/wordpress_files_$DATE.tar.gz" -C /var/www/html . 2>/dev/null; then
    log "✅ WordPress files backup successful"
else
    log "❌ WordPress files backup failed"
fi

# 3. Create backup info file
cat > "$CURRENT_BACKUP_DIR/backup_info.txt" << EOF
Backup Information
==================
Date: $(date)
WordPress Database: wordpress_db_$DATE.sql.gz
WordPress Files: wordpress_files_$DATE.tar.gz
Database Host: mariadb
Database Name: $MYSQL_DATABASE
Backup Size: $(du -sh $CURRENT_BACKUP_DIR | cut -f1)
EOF

# 4. Cleanup old backups (keep last 7 days)
log "Cleaning up old backups..."
find $BACKUP_DIR -type d -name "backup_*" -mtime +7 -exec rm -rf {} \; 2>/dev/null
log "✅ Old backups cleaned"

# 5. Generate backup summary
BACKUP_SIZE=$(du -sh "$CURRENT_BACKUP_DIR" | cut -f1)
TOTAL_BACKUPS=$(ls -1 $BACKUP_DIR | grep backup_ | wc -l)

log "=== BACKUP SUMMARY ==="
log "Backup completed: $CURRENT_BACKUP_DIR"
log "Backup size: $BACKUP_SIZE"
log "Total backups available: $TOTAL_BACKUPS"
log "=== BACKUP PROCESS FINISHED ==="

# 6. Test backup integrity
log "Testing backup integrity..."
if gzip -t "$CURRENT_BACKUP_DIR/wordpress_db_$DATE.sql.gz" 2>/dev/null && tar -tzf "$CURRENT_BACKUP_DIR/wordpress_files_$DATE.tar.gz" >/dev/null 2>&1; then
    log "✅ Backup integrity verified"
else
    log "❌ Backup integrity check failed"
fi

echo "Backup completed successfully at $(date)"
