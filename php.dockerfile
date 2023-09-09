# Use the official PHP 8.2 image for Alpine as a base image
FROM php:8.2-fpm

# Create the necessary directory and install required packages
RUN mkdir -p /var/www/html && \
    apt-get -y update && apt-get -y full-upgrade && \
    apt-get -y install curl libzip-dev libpng-dev git

# Install additional PHP extensions
RUN docker-php-ext-install pdo pdo_mysql exif zip pcntl bcmath gd mysqli

# Install Composer


# Create a composer user (optional)
ARG PHP_INTERPRET_MODE
ARG DOMAIN
ENV DOMAIN=$DOMAIN
ARG URL
ENV URL=$URL
ARG SECURE_URL
ENV SECURE_URL=$SECURE_URL
ARG PHPMYADMIN_PORT
ARG MAX_EXEC_TIME
ARG MEMORY_LIMIT
ARG POST_MAX_SIZE
ARG UPLOAD_MAX_FILE_SIZE
ARG PM_MAX_CHILDREN

# Print the values of ARG variables (for debugging)
RUN echo "PHP_INTERPRET_MODE: $PHP_INTERPRET_MODE" && \
    echo "MEMORY_LIMIT: $MEMORY_LIMIT" && \
    echo "POST_MAX_SIZE: $POST_MAX_SIZE" && \
    echo "UPLOAD_MAX_FILE_SIZE: $UPLOAD_MAX_FILE_SIZE" && \
    echo "PM_MAX_CHILDREN: $PM_MAX_CHILDREN"

# Copy php.ini production configuration to the appropriate location
RUN if [ "$PHP_INTERPRET_MODE" = "development" ]; then \
      cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini; \
    else \
      cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
    fi

# Modify php.ini settings
RUN echo "MEMORY_LIMIT: $MEMORY_LIMIT"

RUN sed -E -i -e "s/max_execution_time = 30/max_execution_time = ${MAX_EXEC_TIME}/" /usr/local/etc/php/php.ini \
 && sed -E -i -e "s/memory_limit = 128M/memory_limit = ${MEMORY_LIMIT}/" /usr/local/etc/php/php.ini \
 && sed -E -i -e "s/post_max_size = 8M/post_max_size = ${POST_MAX_SIZE}/" /usr/local/etc/php/php.ini \
 && sed -E -i -e "s/upload_max_filesize = 2M/upload_max_filesize = ${UPLOAD_MAX_FILE_SIZE}/" /usr/local/etc/php/php.ini

# Configure PHP-FPM settings (optional)
RUN echo "pm.max_children = ${PM_MAX_CHILDREN}" >> /usr/local/etc/php/php-fpm.conf

# Define a working directory (if needed)
RUN useradd -g www-data composer
RUN chown -R root:www-data /var/www/html && chmod -R 777 /var/www/html
WORKDIR /var/www/html
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#USER composer
#RUN cd /var/www/html && composer install
#USER root
# Start the PHP-FPM service
CMD ["php-fpm"]