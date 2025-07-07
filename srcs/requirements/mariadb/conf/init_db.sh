#!/bin/bash
set -e
chown -R mysql:mysql /var/lib/mysql

# Force clean initialization for debugging
echo "Cleaning previous database data..."
rm -rf /var/lib/mysql/*

echo "Initializing MariaDB..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Start MariaDB temporarily for setup
mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock &
MYSQL_PID=$!

# Wait for startup
sleep 8

echo "Creating database and user..."
# Use socket connection for setup
mysql --socket=/tmp/mysql.sock -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql --socket=/tmp/mysql.sock -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql --socket=/tmp/mysql.sock -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql --socket=/tmp/mysql.sock -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql --socket=/tmp/mysql.sock -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';"
mysql --socket=/tmp/mysql.sock -e "FLUSH PRIVILEGES;"

echo "Database setup completed"

# Stop temporary instance
kill $MYSQL_PID
wait $MYSQL_PID 2>/dev/null || true

echo "Starting MariaDB with network enabled..."

# AJOUTER CETTE LIGNE - Démarrer MariaDB en mode production
exec mysqld --user=mysql --datadir=/var/lib/mysql

