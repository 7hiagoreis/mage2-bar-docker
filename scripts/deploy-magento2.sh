#!/bin/bash

set -e

echo "======================================="
echo " Deploy de Produção do Magento (Docker)"
echo "======================================="

cd /var/www/html

# ==============================
# 1. Propriedade Inicial
# ==============================
echo "-> Ajustando as propriedades (Ownership) inicial..."
chown -R www-data:www-data /var/www/html

# ==============================
# 2. Modo Produção
# ==============================
echo "-> Ativando modo produção do Magento..."
su -s /bin/bash www-data -c "php bin/magento deploy:mode:set production" || true

# ==============================
# 3. Atualização (Upgrade)
# ==============================
echo "-> setup:upgrade..."
su -s /bin/bash www-data -c "php bin/magento setup:upgrade"

# ==============================
# 4. Compilar
# ==============================
echo "-> setup:di:compile..."
su -s /bin/bash www-data -c "php bin/magento setup:di:compile"

# ==============================
# 5. Static deploy
# ==============================
echo "-> static-content:deploy..."
su -s /bin/bash www-data -c "php bin/magento setup:static-content:deploy -f"

# ==============================
# 6. Reindexar os dados
# ==============================
echo "-> Reindex..."
su -s /bin/bash www-data -c "php bin/magento indexer:reindex"

# ==============================
# 7. Cache
# ==============================
echo "-> Cache clean/flush..."
su -s /bin/bash www-data -c "php bin/magento cache:clean"
su -s /bin/bash www-data -c "php bin/magento cache:flush"

# ==============================
# 8. Permissões finais
# ==============================
echo "-> Ajustando permissões finais..."

find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

chmod -R 775 var generated pub/static pub/media
chmod 640 app/etc/env.php

# ==============================
# 9. Hardening contra lixo sess_
# ==============================
echo "-> Limpando arquivos maliciosos..."

if [ -d "pub/media/customer_address" ]; then
    find pub/media/customer_address -type f -name "sess_*" -delete
    chmod -R 755 pub/media/customer_address
fi

echo "======================================="
echo " Deploy Finalizado com Sucesso"
echo "======================================="
