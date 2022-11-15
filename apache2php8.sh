#!/bin/bash
echo "Instalando php8.1.12 e httpd-2.4.54"
apt-get update && apt-get install wget gcc make pkg-config libapr1-dev libaprutil1-dev libxml++2.6-dev libsqlite3-dev libbz2-dev libdb-dev libgmp-dev libgdbm-dev libreadline-dev -y
wget https://www.php.net/distributions/php-8.1.12.tar.gz
tar -zxf php-8.1.12.tar.gz && rm -f php-8.1.12.tar.gz
cd php-8.1.12 && ./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --localstatedir=/var         \
            --datadir=/usr/share/php     \
            --mandir=/usr/share/man      \
            --without-pear               \
            --enable-fpm                 \
            --with-fpm-user=apache       \
            --with-fpm-group=apache      \
            --with-config-file-path=/etc \
            --with-zlib                  \
            --enable-bcmath              \
            --with-bz2                   \
            --enable-calendar            \
            --enable-dba=shared          \
            --with-gdbm                  \
            --with-gmp                   \
            --enable-ftp                 \
            --with-gettext               \
            --enable-mbstring            \
            --disable-mbregex            \
            --with-readline              &&
make
make install &&
install -v -m644 php.ini-production /etc/php.ini &&
install -v -m755 -d /usr/share/doc/php-8.1.12 &&
install -v -m644    CODING_STANDARDS* EXTENSIONS NEWS README* UPGRADING* \
/usr/share/doc/php-8.1.12
if [ -f /etc/php-fpm.conf.default ]; then
  mv -v /etc/php-fpm.conf{.default,} &&
  mv -v /etc/php-fpm.d/www.conf{.default,}
fi
sed -i 's@php/includes"@&\ninclude_path = ".:/usr/lib/php"@' \
    /etc/php.ini
cd / && wget https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.gz && tar -zxf httpd-2.4.54.tar.gz && rm -f httpd-2.4.54.tar && mkdir /apache2.4.54
cd httpd-2.4.54 && ./configure -prefix=/apache2.4.54/apache2.4.54 -enable-shared=max
mkdir /apache2.4.54 && ./configure -prefix=/apache2.4.54/apache2.4.54 -enable-shared=max
make && make install
sed -i -e '/proxy_module/s/^#//'      \
       -e '/proxy_fcgi_module/s/^#//' \
       /apache2.4.54/apache2.4.54/conf/httpd.conf
echo \
'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> \
/apache2.4.54/apache2.4.54/conf/httpd.conf
echo "AddType application/x-httpd-php-source .phps" >> /apache2.4.54/apache2.4.54/conf/httpd.conf
echo user = www-data >> /etc/php-fpm.conf && echo group = www-data >> /etc/php-fpm.conf
apt-get clean
/apache2.4.54/apache2.4.54/bin/apachectl restart
php-fpm