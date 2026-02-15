# Restrição de Acesso (Hardening) SSH
## Projeto mage2-bar-docker

Este documento descreve o processo de hardening do serviço SSH no Debian 12, aplicado após a preparação inicial do sistema.

O objetivo é aumentar a segurança do servidor, eliminando autenticação por senha e acesso direto do usuário root.

---

## Criação do diretório SSH do usuário devops

Garantir que o diretório `.ssh` exista e tenha as permissões corretas.

```bash
sudo mkdir -p /home/devops/.ssh
sudo chmod 700 /home/devops/.ssh
sudo chown devops:devops /home/devops/.ssh
```

# Configuração de autenticação por chave pública

A chave pública foi adicionada ao arquivo <mark>authorized_keys</mark> do usuário <mark>devops</mark>.

```bash
sudo vi /home/devops/.ssh/authorized_keys
```

Conteúdo esperado do arquivo:

```bash
ssh-ed25519 AAAA...<CHAVE_PUBLICA_EXEMPLO>ABC... devops
```

Ajustando permissões do arquivo:
```bash
sudo chmod 600 /home/devops/.ssh/authorized_keys
```
```bash
sudo chown devops:devops /home/devops/.ssh/authorized_keys
```

# Teste de autenticação por chave

Antes de qualquer alteração no SSH, foi validado que o acesso por chave pública funciona corretamente para o usuário <mark>devops</mark>.

O login deve ocorrer sem solicitar senha do usuário.

# Endurecimento da configuração do SSH

Edição do arquivo de configuração do SSH:

```bash
sudo vi /etc/ssh/sshd_config
```

Parâmetros aplicados:
```init
PubkeyAuthentication yes
PasswordAuthentication no
PermitRootLogin no
AuthorizedKeysFile .ssh/authorized_keys
```

# Reinicialização do serviço SSH

Aplicando as alterações realizadas:
```bash
sudo systemctl restart ssh
```

Validação do serviço SSH

Verificação do status do serviço:
```bash
systemctl status ssh
```

Testes realizados:

- Login como <mark>devops</mark> utilizando chave pública

- Tentativa de login por senha (bloqueada)

- Tentativa de login como root (bloqueada)


# Considerações de segurança

- O acesso SSH agora é permitido apenas via chave pública

- O usuário root não possui acesso direto via SSH

- Redução significativa da superfície de ataque do servidor
