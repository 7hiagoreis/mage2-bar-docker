#!/bin/bash
set -e

MAGE_ROOT="/var/www/html"
MAGE_USER="www-data"

echo "======================================"
echo "Magento 2 Deploy (Docker + Hardened)"
echo "======================================"

# -------------------------------
# Corrigir as permissões ANTES
# -------------------------------

echo "Ajustando as permissões..."

chown -R $MAGE_USER:www-data $MAGE_ROOT
chmod -R 775 \
    $MAGE_ROOT/var \
    $MAGE_ROOT/generated \
    $MAGE_ROOT/pub/static \
    $MAGE_ROOT/pub/media

# -------------------------------
# Espera o OpenSearch
# -------------------------------

echo "Aguardando o OpenSearch..."
until curl -s http://magento_opensearch:9200/_cluster/health | grep -q '"status":"'; do
    sleep 3
done

# -------------------------------
# Limpeza forte
# -------------------------------

rm -rf $MAGE_ROOT/generated/*
rm -rf $MAGE_ROOT/pub/static/*
rm -rf $MAGE_ROOT/var/cache/*
rm -rf $MAGE_ROOT/var/page_cache/*

# -------------------------------
# Comandos do Magento
# -------------------------------

echo "Executando os comandos do Magento... (atualizar/compilar/deploy)"

su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento setup:upgrade"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento setup:di:compile"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento setup:static-content:deploy pt_BR en_US -f"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento cache:flush"

# -------------------------------
# HARDENING (Segurança)
# -------------------------------

echo "Aplicando hardening..."

rm -rf $MAGE_ROOT/pub/media/customer_address/*
chown root:root $MAGE_ROOT/pub/media/customer_address
chmod 555 $MAGE_ROOT/pub/media/customer_address

find $MAGE_ROOT/pub/media -type f -name "*.php" -delete

chmod +x $MAGE_ROOT/bin/magento

echo "Deploy do Magento finalizado com sucesso!"
