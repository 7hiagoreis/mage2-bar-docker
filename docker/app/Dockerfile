FROM php:8.2-fpm

ENV TZ=America/Sao_Paulo

RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libxml2-dev \
    libxslt1-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libsodium-dev \
    libgmp-dev \
    unzip \
    git \
    curl \
    vim \
    cron \
    && rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    bcmath \
    intl \
    pdo_mysql \
    soap \
    sockets \
    zip \
    gd \
    xsl \
    opcache \
    sodium \
    exif \
    pcntl \
    calendar \
    gmp

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN echo "memory_limit=2G" > /usr/local/etc/php/conf.d/magento.ini \
 && echo "max_execution_time=1800" >> /usr/local/etc/php/conf.d/magento.ini \
 && echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/magento.ini \
 && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/magento.ini

RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
 && echo "opcache.memory_consumption=512" >> /usr/local/etc/php/conf.d/opcache.ini \
 && echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/opcache.ini \
 && echo "opcache.max_accelerated_files=100000" >> /usr/local/etc/php/conf.d/opcache.ini \
 && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
