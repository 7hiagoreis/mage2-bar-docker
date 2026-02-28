FROM php:8.2-fpm

# Instalar as dependências do sistema GNU/Linux
RUN apt update && apt install -y \
    git \
    unzip \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    libsodium-dev \
    libgmp-dev \
    zip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configurar GD do PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Instalar as extensões necessárias para o Magento 2
RUN docker-php-ext-install \
    bcmath \
    ftp \
    pdo \
    pdo_mysql \
    mysqli \
    intl \
    zip \
    gd \
    soap \
    xsl \
    opcache \
    sockets \
    sodium \
    exif \
    pcntl \
    gmp

# Aumentar o memory_limit para CLI e FPM
RUN echo "memory_limit=2G" > /usr/local/etc/php/conf.d/zz-memory-limit.ini

# Instalar o Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
