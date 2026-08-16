# Configurando o ambiente Docker

## mage2-bar-docker

Este documento descreve a configuração do ambiente Docker utilizado para executar o Magento 2.

O ambiente foi organizado para separar os serviços utilizados pelo Magento, permitindo maior organização e facilidade de manutenção.


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


---


# Variáveis de ambiente

As configurações utilizadas pelos containers são armazenadas em variáveis de ambiente.

O projeto disponibiliza um arquivo de exemplo:

```text
.env.exemplo
```

Copie o arquivo para criar o arquivo de configuração local:

```bash
cp .env.exemplo .env
```

O arquivo `.env` contém configurações utilizadas pelos serviços do ambiente Docker.

> **Importante:** o arquivo `.env` não deve ser enviado para o GitHub caso contenha informações sensíveis.


---


# Docker Compose

O arquivo `docker-compose.yml` define os serviços utilizados pelo ambiente Magento 2.

```bash
docker compose config
```

O comando permite verificar a configuração do Docker Compose antes da inicialização dos containers.


---


# Inicializando o ambiente

A inicialização dos serviços será realizada utilizando:

```bash
docker compose up -d
```

Para verificar os containers em execução:

```bash
docker compose ps
```

Para consultar os logs dos serviços:

```bash
docker compose logs
```


---


(em desenvolvimento...)


---
