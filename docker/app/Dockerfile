FROM php:8.2-fpm

ENV TZ=America/Sao_Paulo

# Dependências do sistema
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
    unzip \
    git \
    curl \
    vim \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Extensões obrigatórias Magento 2.4+
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
    calendar

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Ajuste php.ini produção
RUN echo "memory_limit=2G" > /usr/local/etc/php/conf.d/memory.ini \
 && echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/memory.ini \
 && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/memory.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
