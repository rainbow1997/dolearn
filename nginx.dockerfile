FROM nginx:stable-alpine
ARG PHPMYADMIN_PORT
#ENV PHPMYADMIN_PORT=$PHPMYADMIN_PORT
RUN echo "HI ${PHPMYADMIN_PORT}"

ARG DOMAIN
ENV DOMAIN=$DOMAIN
RUN echo "DI ${DOMAIN}"
ARG UPLOAD_MAX_FILE_SIZE
#ENV UPLOAD_MAX_FILE_SIZE=$UPLOAD_MAX_FILE_SIZE


RUN user=nginx && group=nginx && \
    mkdir -p /var/www/html && \
    mkdir -p /var/www/html/public && \
    mkdir -p /var/www/html/storage && \
    mkdir -p /var/www/html/bootstrap && \
    mkdir -p /var/www/html/bootstrap/cache && \
    chown -R ${user}:${group} var/www/html && \
    chown -R 777 /var/www/html/storage && \
    chmod -R 777 /var/www/html/bootstrap/cache && \
    chmod -R 775 /var/www/html

ADD nginx/default.conf /etc/nginx/conf.d/default.conf
#
ADD nginx/pma.conf /etc/nginx/conf.d/pma.conf
