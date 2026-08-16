# Instalando o Docker

## mage2-bar-docker

Este documento descreve o processo de instalação do Docker no Debian 13, utilizando o repositório oficial do Docker.


---


# Removendo pacotes conflitantes

Caso existam versões antigas ou pacotes conflitantes instalados no sistema, eles podem ser removidos antes da instalação:

```bash
sudo apt remove -y docker.io docker-compose docker-doc podman-docker containerd runc
```


---


# Atualizando os pacotes

```bash
sudo apt update
```


---


# Instalando os pacotes necessários

```bash
sudo apt install -y ca-certificates curl
```


---


# Adicionando a chave GPG oficial do Docker

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

```bash
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
```

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```


---


# Adicionando o repositório oficial do Docker

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```


---


# Atualizando os repositórios

```bash
sudo apt update
```


---


# Instalando o Docker Engine

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```


---


# Verificando o serviço do Docker

```bash
sudo systemctl status docker
```

O serviço deve estar ativo.


---


# Habilitando o Docker no início do sistema

```bash
sudo systemctl enable docker
```


---


# Testando a instalação

```bash
sudo docker run hello-world
```


---


O comando executará o container `hello-world` e exibirá uma mensagem confirmando a instalação do Docker. 


---


# Adicionando o usuário devops ao grupo Docker

Para permitir que o usuário `devops` execute comandos Docker sem utilizar `sudo`:

```bash
sudo usermod -aG docker devops
```

Após adicionar o usuário ao grupo, encerre a sessão e faça login novamente para que a alteração tenha efeito.


---


# Testando o Docker sem sudo

Após realizar um novo login com o usuário `devops`:

```bash
docker run hello-world
```

Também é possível verificar a versão instalada:

```bash
docker --version
```

E verificar a versão do Docker Compose:

```bash
docker compose version
```


---


(em desenvolvimento...)



