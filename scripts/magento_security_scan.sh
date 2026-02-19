#!/bin/bash

# Cria a pasta para os relatórios
REPORT_DIR="/var/www/html/magento2/security_reports"
mkdir -p "$REPORT_DIR"

# Nome do arquivo gerado com timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_FILE="$REPORT_DIR/magento_scan_$TIMESTAMP.txt"

echo "Magento Security Scan Report - $TIMESTAMP" > "$REPORT_FILE"
echo "===================================================" >> "$REPORT_FILE"

# 1. Procurar eval(base64_decode)
echo -e "\n[1] Arquivos com eval(base64_decode):" >> "$REPORT_FILE"
grep -R --line-number --binary-files=without-match "eval(base64_decode" /var/www/html/magento2 >> "$REPORT_FILE"

# 2. Procurar eval simples
echo -e "\n[2] Arquivos com eval(" >> "$REPORT_FILE"
grep -R --line-number --binary-files=without-match "eval(" /var/www/html/magento2 >> "$REPORT_FILE"

# 3. Arquivos PHP dentro de pub/media
echo -e "\n[3] Arquivos PHP dentro de pub/media:" >> "$REPORT_FILE"
find /var/www/html/magento2/pub/media -type f -name "*.php" >> "$REPORT_FILE"

# 4. Verificar as permissões de arquivos e diretórios incorretas
echo -e "\n[4] Diretórios com permissão diferente de 755:" >> "$REPORT_FILE"
find /var/www/html/magento2 -type d ! -perm 755 >> "$REPORT_FILE"

echo -e "\n[5] Arquivos com permissão diferente de 644 (exceto app/etc/env.php):" >> "$REPORT_FILE"
find /var/www/html/magento2 -type f ! -name "env.php" ! -perm 644 >> "$REPORT_FILE"

# 5. Env.php
echo -e "\n[6] Verificar permissões do env.php:" >> "$REPORT_FILE"
ls -l /var/www/html/magento2/app/etc/env.php >> "$REPORT_FILE"

echo -e "\nScan completo salvo em: $REPORT_FILE"
