#!/bin/bash
echo "Instalando php8.1.12 e nginx"
echo "Duração 21 minutos em média"
apt-get update && apt-get install nginx gcc make pkg-config libapr1-dev libaprutil1-dev libxml++2.6-dev libsqlite3-dev libbz2-dev libdb-dev libgmp-dev libgdbm-dev libreadline-dev -y
wget https://www.php.net/distributions/php-8.1.12.tar.gz
tar -zxf php-8.1.12.tar.gz && rm -f php-8.1.12.tar.gz
cd php-8.1.12 && ./configure --enable-fpm --with-pdo-mysql && make && make install
cp php.ini-development /usr/local/php/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /usr/local/php/php.ini
cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
cp sapi/fpm/php-fpm /usr/local/bin
cp sapi/fpm/php-fpm.conf /usr/local/etc/php-fpm.conf
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /usr/local/php/php.ini
sed -i 's/user = nobody/user = www-data/' /usr/local/etc/php-fpm.d/www.conf
sed -i 's/group = nobody/group = www-data/' /usr/local/etc/php-fpm.d/www.conf
sed -i '$d' /usr/local/etc/php-fpm.conf
echo "include=/usr/local/etc/php-fpm.d/*.conf" >> /usr/local/etc/php-fpm.conf
cd / && /usr/local/bin/php-fpm
sed -i 's/index index.html/index index.php index.html/' /etc/nginx/sites-available/default

