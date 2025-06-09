#Creer le necessaire en dossiers et permissions
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 755 /var/run/mysqld

#Copy de Mariadb configu file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

#Copy initialization script
COPY conf/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

#Creer les volumes directory et les set 
RUN mkdir -p /vat/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql

#Expose mariadb port
EXPOSE 3306

#Set the user to mysql 
USER mysql

#utiliser une init custom dans un script en entrypoint 
ENTRYPOINT ["/usr/local/bin/init_db.sh"]

#Default command to run Miariab
CMD ["mysqld","--user=mysql", "--datadir=/var/lib/mysql"]

