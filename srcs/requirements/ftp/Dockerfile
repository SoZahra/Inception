FROM debian:11

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Create FTP user directory
RUN mkdir -p /var/ftp \
    && mkdir -p /etc/vsftpd

# Copy configuration files
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY conf/start_ftp.sh /usr/local/bin/start_ftp.sh
RUN chmod +x /usr/local/bin/start_ftp.sh

# Create log directory
RUN mkdir -p /var/log/vsftpd

EXPOSE 21 21000-21010

ENTRYPOINT ["/usr/local/bin/start_ftp.sh"]
CMD ["vsftpd", "/etc/vsftpd.conf"]
