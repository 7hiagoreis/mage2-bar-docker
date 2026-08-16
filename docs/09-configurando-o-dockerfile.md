# Configurando o Dockerfile

## mage2-bar-docker

Este documento descreve a configuração do `Dockerfile` utilizado para criar o container responsável pela execução do Magento 2.

O arquivo está localizado em:

```text
docker/magento2/Dockerfile
```

---

# Imagem base

O container utiliza a imagem oficial do PHP 8.2 com PHP-FPM:

```dockerfile
FROM php:8.2-fpm
```

O PHP-FPM será utilizado pelo Nginx para processar as requisições PHP do Magento 2.

# Variáveis de ambiente

O Dockerfile define algumas variáveis de ambiente utilizadas pelo container:

```dockerfile
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
```

`DEBIAN_FRONTEND` permite realizar a instalação dos pacotes sem interação durante o processo de build.

`TERM` define o tipo de terminal utilizado dentro do container.

# Dependências do sistema

O Dockerfile instala os pacotes necessários para o funcionamento do Magento 2 e para administração do container:

```dockerfile
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
    coreutils
```

Após a instalação, os arquivos utilizados pelo `apt` são removidos para reduzir o tamanho da imagem:

```bash
rm -rf /var/lib/apt/lists/*
```

# Configuração da extensão GD

A extensão GD é configurada para oferecer suporte aos formatos JPEG e fontes TrueType:

```dockerfile
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
```

# Extensões PHP

O Dockerfile instala as extensões PHP necessárias para o funcionamento do Magento 2:

```dockerfile
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
```

Entre elas estão as extensões utilizadas para conexão com o MariaDB, internacionalização, manipulação de arquivos, processamento de imagens, SOAP, cache e outras funcionalidades utilizadas pelo Magento 2.

# Configuração do PHP

O ambiente define alguns limites personalizados para o PHP:

```ini
memory_limit=2G
upload_max_filesize=64M
post_max_size=64M
max_execution_time=1800
```

Essas configurações são gravadas no arquivo:

```text
/usr/local/etc/php/conf.d/zz-memory-limit.ini
```

# Configuração do terminal

O ambiente também adiciona algumas configurações para facilitar a utilização do terminal dentro do container:

```bash
alias ll='ls -lah --color=auto'
alias ls='ls --color=auto'
alias mag='php bin/magento'
```

O alias `mag` permite executar comandos do Magento utilizando:

```bash
mag
```

em vez de:

```bash
php bin/magento
```

# Instalação do Composer

O Composer é copiado diretamente da imagem oficial do Composer:

```dockerfile
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
```

Dessa forma, o Composer fica disponível dentro do container.

# Diretório de trabalho

O diretório de trabalho do container é definido como:

```dockerfile
WORKDIR /var/www/html
```

Esse diretório será utilizado pelo Magento 2 dentro do container.

# Shell padrão

O Bash é definido como shell padrão utilizado durante a construção da imagem:

```dockerfile
SHELL ["/bin/bash", "-c"]
```

---

(em desenvolvimento...)
