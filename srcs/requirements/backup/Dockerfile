FROM debian:11

RUN apt-get update && apt-get install -y \
    cron \
    mariadb-client \
    gzip \
    tar \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create backup user (ignore if exists)
RUN useradd -r -s /bin/bash backup || true
RUN mkdir -p /backups /var/log/backup
RUN chown -R backup:backup /backups /var/log/backup

COPY conf/backup.sh /usr/local/bin/backup.sh
COPY conf/start_backup.sh /usr/local/bin/start_backup.sh
COPY conf/crontab /etc/cron.d/backup-cron

RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/start_backup.sh
RUN chmod 0644 /etc/cron.d/backup-cron

RUN touch /var/log/backup/backup.log
RUN chown backup:backup /var/log/backup/backup.log

WORKDIR /backups

ENTRYPOINT ["/usr/local/bin/start_backup.sh"]
CMD ["cron", "-f"]
