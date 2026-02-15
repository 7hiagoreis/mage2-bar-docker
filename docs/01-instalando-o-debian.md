# Preparando o Debian 12 para o Projeto - mage2-bar-docker
## Projeto mage2-bar-docker

Este documento descreve o processo de hardening do serviço SSH no Debian 12, aplicado após a preparação inicial do sistema.

O objetivo é aumentar a segurança do servidor, eliminando autenticação por senha e acesso direto do usuário root.

---


# Após a instalação do Debian 12 em máquina virtual, foi realizado as seguintes etapas para preparar o servidor...

# Atualizar o sistema
```bash
sudo apt update && sudo apt upgrade -y
```
# Instalar os pacotes básicos
```bash
sudo apt install -y curl gnupg lsb-release sudo software-properties-common apt-transport-https ca-certificates
```
# Adicionando usuario devops para controle do servidor
```bash
adduser devops
```
```bash
usermod -aG sudo devops
```
# Instalando e configurando o fail2ban
```bash
sudo apt install -y fail2ban
```
```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

# Adicionado a configuração minima do fail2ban no arquivo jail.local
```bash
sudo vi /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
```

# Habilitando, testando e reiniciando o fail2ban
```bash
sudo systemctl enable fail2ban
```
```bash
sudo systemctl restart fail2ban
```
```bash
sudo fail2ban-client status
```
```bash
sudo fail2ban-client status sshd
```


