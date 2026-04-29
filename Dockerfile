FROM php:8.2-apache

# Install PDO MySQL extension
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite (optional but good practice)
RUN a2enmod rewrite

# Set permissions for uploads folder
RUN mkdir -p /var/www/html/uploads && \
    chmod -R 777 /var/www/html/uploads

WORKDIR /var/www/html
