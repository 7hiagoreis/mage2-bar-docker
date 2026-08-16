# Configurando o ambiente Docker

## mage2-bar-docker

Este documento descreve a configuração do ambiente Docker utilizado pelo projeto `mage2-bar-docker`.

O ambiente é composto por containers independentes para o Magento 2, banco de dados, cache, mecanismo de pesquisa e servidor web.

---

# Estrutura do ambiente

Os arquivos relacionados ao ambiente Docker estão organizados em:

```text
docker/
└── magento2/
    ├── data/
    ├── nginx/
    │   └── ssl/
    ├── .env.exemplo
    ├── Dockerfile
    └── docker-compose.yml
```

# Serviços utilizados

O ambiente Docker é composto pelos seguintes serviços:

### MariaDB

O container `magento_db` utiliza a imagem `mariadb:10.6`.

O MariaDB é utilizado pelo Magento 2 para armazenar os dados da aplicação, como produtos, pedidos, clientes e configurações.

Os dados são persistidos no host através do volume:

```text
./data/db:/var/lib/mysql
```

### Redis

O container `magento_redis` utiliza a imagem `redis:7`.

O Redis é utilizado pelo Magento 2 para cache e gerenciamento de sessões.

A persistência dos dados é realizada através do volume:

```text
./data/redis:/data
```

O acesso ao Redis é protegido por senha definida através da variável `REDIS_PASSWORD`.

### OpenSearch

O container `magento_opensearch` utiliza a imagem:

```text
opensearchproject/opensearch:2.11.1
```

O OpenSearch é utilizado pelo Magento 2 para realizar as pesquisas no catálogo de produtos.

O ambiente utiliza o OpenSearch em modo `single-node`, adequado para o ambiente de desenvolvimento.

Os dados dos índices são persistidos no host através do volume:

```text
./data/opensearch:/usr/share/opensearch/data
```

### Magento 2

O container `magento_server` é construído a partir do `Dockerfile` presente no diretório:

```text
docker/magento2/
```

Esse container executa o Magento 2 utilizando PHP-FPM.

O código da aplicação é montado através do volume:

```text
../magento2:/var/www/html
```

O container depende dos serviços:

```text
magento_db
magento_redis
magento_opensearch
```

### Nginx

O container `magento_nginx` utiliza a imagem `nginx:alpine`.

O Nginx funciona como servidor web e recebe as requisições HTTP e HTTPS, encaminhando as requisições PHP para o container `magento_server`.

As portas utilizadas são:

```text
80:80
443:443
```

A configuração personalizada do Nginx é montada através de:

```text
./nginx/default.conf:/etc/nginx/conf.d/default.conf
```

Os certificados SSL são disponibilizados através de:

```text
./nginx/ssl:/etc/nginx/ssl
```

# Rede Docker

Os containers utilizam uma rede interna chamada:

```text
magento_net
```

A rede utiliza o driver `bridge` e permite a comunicação entre os serviços do ambiente Magento.

```text
magento_net
│
├── magento_db
├── magento_redis
├── magento_opensearch
├── magento_server
└── magento_nginx
```

# Variáveis de ambiente

As credenciais e configurações sensíveis são armazenadas em variáveis de ambiente.

O projeto utiliza o arquivo:

```text
.env
```

O arquivo de exemplo disponibilizado pelo projeto é:

```text
.env.exemplo
```

Para criar o arquivo local:

```bash
cp .env.exemplo .env
```

O arquivo `.env` não deve ser enviado para o GitHub quando contiver informações sensíveis.

# Iniciando os containers

Dentro do diretório `docker/magento2/`, execute:

```bash
docker compose up -d
```

Para verificar os containers:

```bash
docker compose ps
```

Para visualizar os logs:

```bash
docker compose logs
```

Para visualizar os logs de um serviço específico:

```bash
docker compose logs magento_server
```

---

(em desenvolvimento...)
