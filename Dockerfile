FROM php:5.6-apache

# update env
RUN apt-get update
RUN apt-get install -y software-properties-common \
    imagemagick \
    graphicsmagick \
    curl \
    gcc \
    libgpgme11-dev \
    libmemcached-dev zlib1g-dev memcached nano libgd-dev git wget
RUN pecl install gnupg && docker-php-ext-enable gnupg
RUN pecl install memcache-2.2.7 && docker-php-ext-enable memcache
RUN docker-php-ext-install mysql bcmath gd

# Install composer
RUN cd /tmp && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir="/usr/local/bin" --filename=composer && \
    php -r "unlink('composer-setup.php');"
# Install phalcon 1.3.4
COPY cphalcon-phalcon-v1.3.4 /tmp/phalcon1.3.4
RUN cd /tmp/phalcon1.3.4/build && ./install && docker-php-ext-enable phalcon
RUN a2enmod rewrite
RUN mkdir /var/moodledata
#COPY ./index.php /var/www/html/
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
WORKDIR /var/www/html

