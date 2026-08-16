# Instalando o Composer

## mage2-bar-docker

Este documento descreve o processo de instalação do Composer no Debian 13 para utilização no projeto `mage2-bar-docker`.


---


# Verificando a instalação do PHP

O Composer necessita do PHP para funcionar. Antes da instalação, vamos verificar se o PHP está disponível no sistema:

```bash
php -v
```


---


# Instalando o Composer

O instalador oficial do Composer será baixado utilizando o `curl`:

```bash
curl -sS https://getcomposer.org/installer -o composer-setup.php
```

Após o download, execute o instalador:

```bash
php composer-setup.php
```

O Composer será instalado no diretório atual.


---


# Instalando o Composer globalmente

Para disponibilizar o Composer para todos os usuários do sistema:

```bash
sudo mv composer.phar /usr/local/bin/composer
```


---


# Verificando a instalação

```bash
composer --version
```

O comando exibirá a versão instalada do Composer.


---


(em desenvolvimento...)
