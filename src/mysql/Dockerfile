FROM alpine


RUN apk update \
	&& apk add openrc \
	&& apk add --no-cache mysql mysql-client \
 	&& addgroup mysql mysql \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /run/mysqld \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql \
	&& chmod 1777 /var/run/mysqld /var/lib/mysql 

RUN openrc boot
COPY mysql.cnf /etc/my.cnf
COPY creatdb.sql /creatdb.sql
COPY ./setup_mysql.sh .
COPY wordpress.sql .

RUN chmod 777 setup_mysql.sh
EXPOSE 3306
ENTRYPOINT [ "./setup_mysql.sh" ]