FROM phpmyadmin/phpmyadmin
RUN a2enmod ssl
ARG DOMAIN
#ENV DOMAIN=$DOMAIN
# Switch to default SSL Port 443 instead of 80
RUN sed -ri -e 's,80,443,' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLEngine on' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLCertificateFile /etc/ssl/myhost/dolearn.test.pem' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLCertificateKeyFile /etc/ssl/myhost/dolearn.test.key.pem' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLCertificateChainFile /etc/ssl/myhost/dolearn.test.pem' /etc/apache2/sites-available/000-default.conf
