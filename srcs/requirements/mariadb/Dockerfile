# Use Debian 11 (Bullseye) - penultimate stable version
FROM debian:11

# Update package lists and install MariaDB server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/lib/mysql /tmp \
    && chown -R mysql:mysql /var/lib/mysql \
    && chmod 755 /var/lib/mysql

# Copy MariaDB configuration file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY conf/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# Expose MariaDB port
EXPOSE 3306

# Run as root (needed for volume permissions)
USER root

# Use custom initialization script as entrypoint
ENTRYPOINT ["/usr/local/bin/init_db.sh"]

# Default command to run MariaDB
CMD ["mysqld", "--user=mysql"]
