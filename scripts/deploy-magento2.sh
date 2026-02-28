#!/bin/bash
set -e

MAGE_ROOT="/var/www/html"
MAGE_USER="www-data"

echo "======================================"
echo "Magento 2 Deploy (Docker)"
echo "======================================"

# -------------------------------
# Espera o OpenSearch
# -------------------------------
echo "Aguardando OpenSearch..."
until curl -s http://magento_opensearch:9200/_cluster/health | grep -q '"status":"'; do
    sleep 3
done

# -------------------------------
# Rodar Magento como www-data
# -------------------------------
echo "Executando comandos Magento..."

su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento cache:clean"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento cache:flush"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento indexer:reindex"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento setup:upgrade"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento setup:di:compile"
su -s /bin/bash $MAGE_USER -c "php $MAGE_ROOT/bin/magento setup:static-content:deploy -f"

# -------------------------------
# Ajustar somente pastas críticas
# -------------------------------
echo "Ajustando permissões Magento..."

chown -R $MAGE_USER:www-data \
    $MAGE_ROOT/var \
    $MAGE_ROOT/generated \
    $MAGE_ROOT/pub/static \
    $MAGE_ROOT/pub/media

chmod -R 775 \
    $MAGE_ROOT/var \
    $MAGE_ROOT/generated \
    $MAGE_ROOT/pub/static \
    $MAGE_ROOT/pub/media

# Garantir bin executável
chmod +x $MAGE_ROOT/bin/magento

echo "Deploy finalizado com sucesso!"
