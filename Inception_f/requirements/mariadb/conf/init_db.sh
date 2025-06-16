#!/bin/bash
set -e

# Check if database directory is empty (first run)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."

    # Install the database
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB in background for setup
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    MYSQL_PID=$!

    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    for i in {1..30}; do
        if mysqladmin ping --silent; then
            break
        fi
        sleep 1
    done

    echo "Setting up database and users..."

    # Execute SQL commands
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -e "DELETE FROM mysql.user WHERE User='';"
    mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -e "DROP DATABASE IF EXISTS test;"
    mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

    # Create WordPress database and user
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    echo "Database setup completed."

    # Stop the background MariaDB instance
    mysqladmin shutdown
    wait $MYSQL_PID
fi

echo "Starting MariaDB..."

# Execute the command passed to docker run
exec "$@"