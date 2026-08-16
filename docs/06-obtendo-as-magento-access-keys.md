# Obtendo as Magento Access Keys

## mage2-bar-docker

Este documento descreve o processo para obter as **Magento Access Keys**, necessárias para autenticação do Composer no repositório `repo.magento.com`.


---


# Acessando as Magento Access Keys

As chaves podem ser obtidas diretamente na página do Adobe Commerce Marketplace:

**Magento Access Keys:**
https://commercemarketplace.adobe.com/customer/accessKeys/

Após acessar a página, faça login com a sua conta Adobe/Magento.

Na página de Access Keys, serão disponibilizadas as seguintes credenciais:

* **Public Key** → utilizada como usuário no Composer
* **Private Key** → utilizada como senha no Composer

# Atenção com a Private Key

A **Private Key é uma credencial de acesso** e não deve ser armazenada no GitHub ou compartilhada publicamente.

Utilize a chave somente no ambiente em que o Magento será instalado ou atualizado.

As Access Keys serão utilizadas posteriormente para autenticar o Composer no repositório:

```text
repo.magento.com
```


---


(em desenvolvimento...)
