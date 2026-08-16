# Configurando o SSL
## mage2-bar-docker

Este documento descreve a configuração do certificado SSL utilizado pelo Nginx para estabelecer conexões HTTPS com o Magento 2.

Os arquivos de certificado são utilizados pelo container `magento_nginx`.

---

# Arquivos SSL

Os certificados utilizados pelo projeto ficam no diretório:

```text
docker/magento2/nginx/ssl/
```

A estrutura esperada é:

```text
docker/magento2/nginx/ssl/
├── seusite.com.br.pem
├── seusite.com.br.key
├── private.key.example
└── ...
```

O arquivo `.pem` contém o certificado utilizado pelo Nginx.

O arquivo `.key` contém a chave privada correspondente ao certificado.

---

# Gerando um certificado para ambiente de desenvolvimento

Para ambientes de desenvolvimento e laboratório, é possível gerar um certificado autoassinado utilizando o OpenSSL.

Instale o OpenSSL:

```bash
sudo apt install -y openssl
```

Acesse o diretório dos certificados:

```bash
cd docker/magento2/nginx/ssl/
```

Gere a chave privada:

```bash
openssl genrsa -out seusite.com.br.key 2048
```

O comando criará:

```text
seusite.com.br.key
```

Essa é a chave privada utilizada pelo Nginx.

**Nunca envie esse arquivo para o GitHub.**

---

# Gerando o certificado público

Depois de gerar a chave privada, crie um certificado autoassinado:

```bash
openssl req -new -x509 \
  -key seusite.com.br.key \
  -out seusite.com.br.pem \
  -days 365
```

Durante o processo, o OpenSSL solicitará algumas informações do certificado.

O campo `Common Name (CN)` deve corresponder ao domínio utilizado no ambiente.

Exemplo:

```text
Common Name (e.g. server FQDN or YOUR name) []:seusite.com.br
```

Ao final, serão criados:

```text
seusite.com.br.key
seusite.com.br.pem
```

A relação entre os arquivos é:

```text
seusite.com.br.key
        │
        │ utilizada para gerar
        ▼
seusite.com.br.pem
```

A chave privada e o certificado precisam corresponder entre si.

> **Importante:** certificados autoassinados são adequados para desenvolvimento, laboratório e testes. Para produção, utilize um certificado emitido por uma autoridade certificadora confiável.

---

# Verificando os arquivos

Verifique se os arquivos foram criados:

```bash
ls -l
```

A estrutura deverá conter:

```text
seusite.com.br.pem
seusite.com.br.key
```

A chave privada deve permanecer protegida no ambiente local ou no servidor.

---

# Certificado público

O certificado público utilizado pelo Nginx é:

```text
seusite.com.br.pem
```

O arquivo é montado dentro do container através do `docker-compose.yml`:

```yaml
- ./nginx/ssl:/etc/nginx/ssl
```

Dessa forma, o certificado fica disponível dentro do container em:

```text
/etc/nginx/ssl/seusite.com.br.pem
```

O certificado público pode permanecer no repositório quando não contiver informações privadas.

---

# Chave privada

A chave privada utilizada pelo certificado é:

```text
seusite.com.br.key
```

Dentro do container, ela fica disponível em:

```text
/etc/nginx/ssl/seusite.com.br.key
```

O Nginx utiliza esse arquivo através da diretiva:

```nginx
ssl_certificate_key /etc/nginx/ssl/seusite.com.br.key;
```

A chave privada deve permanecer somente no ambiente local ou no servidor onde o projeto estiver sendo executado.

**Nunca envie uma chave privada real para o GitHub.**

---

# Proteção da chave privada no Git

As chaves privadas possuem a extensão `.key` e são ignoradas pelo Git através do `.gitignore`:

```gitignore
docker/magento2/nginx/ssl/*.key
```

Dessa forma, arquivos com extensão `.key` dentro do diretório de certificados não serão adicionados ao repositório.

O objetivo é evitar que uma chave privada seja enviada acidentalmente para o GitHub.

---

# Arquivo de exemplo

O projeto possui um arquivo de exemplo para indicar o formato esperado da chave privada:

```text
private.key.example
```

Esse arquivo não contém uma chave real.

Seu conteúdo possui apenas uma orientação para criação da chave no ambiente local:

```text
ATENÇÃO:
NUNCA coloque uma chave privada real neste arquivo.
NUNCA envie ou faça commit de uma chave privada para o GitHub.

Este arquivo é apenas um exemplo.
Substitua o conteúdo abaixo por sua chave privada SOMENTE no ambiente local.
```

A chave privada real deve ser criada ou copiada somente no ambiente onde o Magento será executado.

---

# Configuração no Nginx

O Nginx utiliza os seguintes arquivos para habilitar HTTPS:

```nginx
ssl_certificate /etc/nginx/ssl/seusite.com.br.pem;
ssl_certificate_key /etc/nginx/ssl/seusite.com.br.key;
```

O certificado público e a chave privada precisam corresponder entre si.

---

# Versões do TLS

O Nginx está configurado para aceitar somente TLS 1.2 e TLS 1.3:

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
```

Versões antigas do protocolo TLS não são utilizadas neste ambiente.

---

# HTTPS

As requisições recebidas através da porta 80 são redirecionadas para HTTPS.

O Nginx recebe as conexões HTTPS através da porta 443:

```nginx
listen 443 ssl;
http2 on;
```

O fluxo de acesso fica:

```text
Navegador
    │
    │ HTTPS :443
    ▼
Nginx
    │
    │ PHP-FPM :9000
    ▼
Magento 2
```

---

# Cuidados com certificados

A chave privada deve ser tratada como um segredo.

Não coloque uma chave privada real:

- no GitHub;
- em arquivos de documentação;
- em exemplos publicados;
- em mensagens de commit;
- em arquivos de configuração versionados.

O certificado público `.pem`, quando não contém informações privadas, pode ser versionado conforme a necessidade do projeto.

---

(em desenvolvimento...)
