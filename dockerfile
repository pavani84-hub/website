FROM hshar/webapp
COPY . /var/www/html
WORKDIR /var/www/html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
