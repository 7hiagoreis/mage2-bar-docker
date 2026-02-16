# Configuração do Firewall
## Projeto mage2-bar-docker

Este documento descreve a configuração inicial do firewall utilizando **UFW (Uncomplicated Firewall)** no Debian 12, com foco em segurança básica e controle de acesso ao servidor.

O firewall foi configurado após a validação do acesso SSH por chave pública, evitando o risco de perda de acesso remoto.

---

## Instalação do UFW

```bash
sudo apt install -y ufw
```

# Políticas padrão do firewall
As políticas padrão foram definidas para bloquear todo o tráfego de entrada e permitir todo o tráfego de saída.

```bash
sudo ufw default deny incoming
```
```bash
sudo ufw default allow outgoing
```

# Liberação do acesso SSH
Antes de ativar o firewall, foi liberado o acesso SSH para evitar bloqueio do acesso remoto.

```bash
sudo ufw allow ssh
```
Ou explicitamente pela porta 22/TCP:

```bash
sudo ufw allow 22/tcp
```

Ativação do UFW
```bash
sudo ufw enable
```
Durante a ativação, o sistema pode alertar sobre a possibilidade de interromper conexões SSH existentes. A ativação foi confirmada após validação da regra de SSH.

Verificação do status do firewall
```bash
sudo ufw status
```
Saída esperada:

- Status: active
```init
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
```

# Integração com Fail2Ban

O UFW foi configurado para trabalhar em conjunto com o Fail2Ban, permitindo o bloqueio automático de endereços IP que excedam tentativas de autenticação inválidas via SSH.

Nenhuma configuração adicional foi necessária neste estágio, pois o Fail2Ban aplica regras diretamente no firewall.


# Considerações de segurança

Todo tráfego de entrada é bloqueado por padrão

- Apenas o serviço SSH está liberado

- O firewall é iniciado automaticamente no <mark>boot</mark>

- Redução significativa de ataque ao servidor
