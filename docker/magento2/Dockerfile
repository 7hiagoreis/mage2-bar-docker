# ||| Inicio ||| 
FROM php:8.2-fpm

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# Instalar as dependências do sistema e bash
RUN apt update && apt install -y \
    bash \
    bash-completion \
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
    vim \
    nano \
    htop \
    dnsutils \
    procps \
    iputils-ping \
    net-tools \
    coreutils \
    && rm -rf /var/lib/apt/lists/*


# -----------------------------------------------------------------------
# Este comando abaixo prepara a extensão GD do PHP para compilar com:
#  - Suporte a fontes TrueType (--with-freetype)
#  - Suporte a imagens JPEG (--with-jpeg)
# Isso garante que o PHP consiga ler, manipular e criar imagens
# nesses formatos dentro do container Docker.
# -----------------------------------------------------------------------
# Configurar o GD do PHP
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

# Ajustar os limites do PHP
RUN echo "memory_limit=2G" > /usr/local/etc/php/conf.d/zz-memory-limit.ini \
    && echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/zz-memory-limit.ini \
    && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/zz-memory-limit.ini \
    && echo "max_execution_time=1800" >> /usr/local/etc/php/conf.d/zz-memory-limit.ini

# Configurar o terminal do container com cores e aliases
RUN echo "export TERM=xterm-256color" >> /root/.bashrc \
    && echo "alias ll='ls -lah --color=auto'" >> /root/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc \
    && echo "alias mag='php bin/magento'" >> /root/.bashrc \
    && echo "export CLICOLOR=1" >> /root/.bashrc \
    && echo "PS1='\\[\\033[01;32m\\]\\u@\\h:\\w \\$\\[\\033[00m\\] '" >> /root/.bashrc

# Instalar o Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Definir o bash como shell padrão
SHELL ["/bin/bash", "-c"]

# ||| Fim ||| 
