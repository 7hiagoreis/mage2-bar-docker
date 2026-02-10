FROM php:8.2-apache

# Timezone (Importante para logs, cron, Magento etc)
ENV TZ=America/Sao_Paulo

# Dependências do Sistema
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libxml2-dev \
    libxslt1-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    unzip \
    git \
    curl \
    vim \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Extensões PHP exigidas pelo Magento 2
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    bcmath \
    intl \
    pdo_mysql \
    soap \
    sockets \
    zip \
    gd \
    xsl

# Apache: mod_rewrite (Obrigatório para Magento 2)
RUN a2enmod rewrite

# Apache: DocumentRoot Obrigatório (/pub)
RUN sed -ri \
  -e 's!/var/www/html!/var/www/html/magento2/pub!g' \
  /etc/apache2/sites-available/*.conf \
  /etc/apache2/apache2.conf

# Composer (Obrigatório para instalar o Magento)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Permissões (Apache)
RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html

# Diretório Principal de Trabalho do Magento 2
WORKDIR /var/www/html/magento2

# Expor porta 80 (Documentação)
EXPOSE 80
