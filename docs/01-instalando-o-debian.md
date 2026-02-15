Preparando o Debian 12 para o Projeto - mage2-bar-docker

# Após a instalação do Debian 12 em máquina virtual, foi realizado as seguintes etapas para preparar o servidor...

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar os pacotes básicos
sudo apt install -y curl gnupg lsb-release sudo software-properties-common apt-transport-https ca-certificates

# Adicionando usuario devops para controle do servidor
adduser devops
usermod -aG sudo devops

# Instalando e configurando o fail2ban
```bash
sudo apt install -y fail2ban
```
```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

# Adicionado a configuração minima do fail2ban no arquivo jail.local
sudo vi /etc/fail2ban/jail.local

[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true

# Habilitando, testando e reiniciando o fail2ban
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

sudo fail2ban-client status
sudo fail2ban-client status sshd


