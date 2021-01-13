#!/bin/sh

# start the MariaDB daemon with:
mysql_install_db --datadir=/var/lib/mysql
rc-service mariadb restart
#### creat data base  ####
mysql -u root mysql < ./creatdb.sql
# rc-service mariadb restart
#mysql -u root wordpress < ./wordpress.sql

rc-service mariadb stop
mysqld --user=root