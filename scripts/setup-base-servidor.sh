#!/bin/bash

LOGFILE="/var/log/setup-base-$(date +%F-%H%M).log"
exec > >(tee -a $LOGFILE) 2>&1

echo "Iniciando a Instalação Base do Servidor..."
sleep 2

if [ "$EUID" -ne 0 ]
  then echo "Não Permitido! ... Execute como root!"
  exit
fi

echo "Atualizando o Sistema..."
apt update && apt upgrade -y

echo "Configurando Timezone..."
timedatectl set-timezone America/Sao_Paulo

echo "Instalando Pacotes essenciais..."
apt install -y \
    curl \
    wget \
    git \
    ufw \
    fail2ban \
    ca-certificates \
    gnupg \
    lsb-release

echo "Configurando o Firewall..."
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw --force enable

echo "Instalando o Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "Criando a Estrutura Base..."
mkdir -p /srv/docker
mkdir -p /srv/backups

echo "Ativando o Fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban

echo "Instalação Concluída com Sucesso!"
echo "O arquivo de Log foi salvo em $LOGFILE"
