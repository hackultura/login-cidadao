FROM php:5.4-apache

RUN apt-get update \
    && apt-get install -y git libssl-dev zlib1g-dev libicu-dev g++ php5-pgsql libpq-dev nodejs nodejs-legacy npm \
    && pecl install zip \
    && echo extension=zip.so > /usr/local/etc/php/conf.d/zip.ini \
    && pecl install pdo_pgsql \
    && echo extension=pdo_pgsql.so > /usr/local/etc/php/conf.d/pdo_pgsql.ini \
    && pecl install apcu-beta \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
    && docker-php-ext-install zip mbstring intl pdo_pgsql

ADD compose/vhost.conf /etc/apache2/sites-enabled/000-default.conf
ADD compose/php.ini /usr/local/etc/php/php.ini

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ADD . /var/www/symfony

RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www/symfony/app/cache
RUN chown -R www-data:www-data /var/www/symfony/app/logs
RUN chown -R www-data:www-data /var/www/symgony/web/uploads

WORKDIR /var/www/symfony
