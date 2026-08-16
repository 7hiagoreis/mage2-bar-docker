# Configurando o Nginx
## mage2-bar-docker

Este documento descreve a configuração do Nginx utilizado como servidor web do Magento 2.

O arquivo de configuração está localizado em:

```text
docker/magento2/nginx/default.conf
```

---

# Comunicação com o PHP-FPM

O Nginx encaminha as requisições PHP para o container `magento_server` através da porta `9000`:

```nginx
upstream fastcgi_backend {
    server magento_server:9000;
}
```

O nome `magento_server` corresponde ao container definido no `docker-compose.yml`.

# Rate Limit

O ambiente possui uma limitação básica de requisições por endereço IP:

```nginx
limit_req_zone $binary_remote_addr zone=one:10m rate=5r/s;
```

Essa configuração limita cada endereço IP a 5 requisições por segundo.

Na aplicação principal, é permitido um burst de até 20 requisições:

```nginx
limit_req zone=one burst=20 nodelay;
```

Essa configuração fornece uma proteção básica contra excesso de requisições automatizadas.

# Redirecionamento HTTP para HTTPS

As requisições recebidas na porta 80 são redirecionadas para HTTPS:

```nginx
server {
    listen 80;
    server_name seusite.com.br www.seusite.com.br;

    return 301 https://$host$request_uri;
}
```

O acesso através de HTTP é direcionado para uma conexão segura utilizando HTTPS.

O bloco também rejeita requisições feitas diretamente através de endereços IP:

```nginx
if ($host ~* "\d+\.\d+\.\d+\.\d+") {
    return 444;
}
```

# Configuração HTTPS

O Nginx recebe as conexões HTTPS na porta 443:

```nginx
listen 443 ssl;
http2 on;
```

Os certificados são montados no container através do volume definido no `docker-compose.yml`.

O certificado público utilizado pelo Nginx é:

```text
/etc/nginx/ssl/seusite.com.br.pem
```

A chave privada utilizada pelo certificado é:

```text
/etc/nginx/ssl/seusite.com.br.key
```

A chave privada não deve ser enviada para o GitHub.

São permitidas as versões TLS 1.2 e TLS 1.3:

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
```

# Cabeçalhos de segurança

O Nginx adiciona alguns cabeçalhos HTTP relacionados à segurança:

```nginx
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
add_header Referrer-Policy "strict-origin-when-cross-origin";
add_header Content-Security-Policy "upgrade-insecure-requests";
```

Esses cabeçalhos ajudam a aplicar políticas adicionais de segurança ao navegador.

# Configuração do Magento

O diretório principal do Magento é definido como:

```nginx
set $MAGE_ROOT /var/www/html;
```

O Nginx utiliza o diretório `pub` como raiz pública:

```nginx
root $MAGE_ROOT/pub;
```

O ambiente utiliza o modo `developer`:

```nginx
set $MAGE_MODE developer;
```

# Bloqueio das APIs

As APIs REST e GraphQL estão bloqueadas neste ambiente:

```nginx
location ~ ^/(rest|graphql) {
    return 444;
}
```

Essa configuração foi definida para o cenário específico do projeto.

# Arquivos estáticos

O Nginx possui uma configuração específica para os arquivos estáticos do Magento:

```nginx
location /static/ {

    location ~ ^/static/version {
        rewrite ^/static/(version\d*/)?(.*)$ /static/$2 last;
    }

    try_files $uri $uri/ /static.php?resource=$uri&$args;
    expires max;
    access_log off;
}
```

Os arquivos são servidos diretamente quando disponíveis. Quando necessário, o Magento utiliza o `static.php` para processar o recurso solicitado.

# Arquivos de mídia

Os arquivos de mídia são disponibilizados através da rota:

```nginx
location /media/ {
    try_files $uri $uri/ /get.php?$args;
    expires max;
    access_log off;
}
```

A execução de arquivos PHP dentro do diretório de mídia é bloqueada:

```nginx
location ~* \.php$ {
    deny all;
}
```

# Bloqueio de arquivos sensíveis

O Nginx bloqueia o acesso direto a determinados arquivos que podem conter informações sensíveis:

```nginx
location ~* \.(env|log|sql|lock|bak|gz|exe|piff)$ {
    deny all;
}
```

Também são bloqueados os diretórios internos do Magento:

```nginx
location ~* /(app|var|vendor|setup|dev)/ {
    deny all;
}
```

Arquivos e diretórios ocultos também são bloqueados:

```nginx
location ~ /\. {
    deny all;
}
```

# Processamento do PHP

As requisições para arquivos PHP são encaminhadas para o PHP-FPM:

```nginx
location ~ \.php$ {
    try_files $uri =404;

    fastcgi_pass fastcgi_backend;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

    fastcgi_param HTTPS on;
    fastcgi_param SERVER_PORT 443;

    include fastcgi_params;

    fastcgi_buffers 16 16k;
    fastcgi_buffer_size 32k;
}
```

O PHP-FPM está sendo executado no container `magento_server`.

A comunicação entre o Nginx e o PHP-FPM ocorre através da rede interna `magento_net`.

---

(em desenvolvimento...)
