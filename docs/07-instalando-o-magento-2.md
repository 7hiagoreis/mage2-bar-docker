# Instalando o Magento 2

## mage2-bar-docker

Este documento descreve a instalação do **Magento 2 Community Edition** utilizando o Composer.


---


# Criando o diretório do projeto

```bash
mkdir -p ~/mage2-bar-docker
```

Acesse o diretório:

```bash
cd ~/mage2-bar-docker
```


---


# Configurando a autenticação do Composer

Configure as **Magento Access Keys** obtidas anteriormente para permitir o acesso ao repositório `repo.magento.com`:

```bash
composer config --global http-basic.repo.magento.com <PUBLIC_KEY> <PRIVATE_KEY>
```

Substitua `<PUBLIC_KEY>` e `<PRIVATE_KEY>` pelas respectivas Access Keys.


---


# Instalando o Magento 2

Instale o Magento 2 Community Edition utilizando o Composer:

```bash
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
```

O Composer fará o download do Magento 2 e de suas dependências para o diretório do projeto.


---


# Verificando os arquivos do Magento

Após a instalação, verifique a estrutura criada:

```bash
ls -la
```

A instalação deverá conter, entre outros, os diretórios:

```text
app/
bin/
dev/
generated/
lib/
phpserver/
pub/
setup/
var/
vendor/
```

---

(em desenvolvimento...)


---

