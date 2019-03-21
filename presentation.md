title: Introdução a Docker
class: animation-fade
layout: true

<!-- This slide will serve as the base layout for all your slides -->
.bottom-bar[
  {{title}}
]

---

class: impact

# {{title}}
## With a good subtitle :-)

---

# O que é um contêiner?

* Permite você definir e empacotar um ambiente de execução dentro de uma imagem executável.

* Essa image pode conter:
  * Binários de uma aplicação
  * Configurações para uma aplicação
  * Todas as suas dependências
  * Configurações de sistema (arquivos, diretórios, variáveis de ambiente, etc.)

---

# O que é um contêiner?

* Utiliza o sistema operacional para **isolar** o processo, rede e sistema de arquivo do contêiner para que aparente que seja um ambiente de servidor auto-contido

* contêiners devem ser pensados como sendo **imutáveis**
 * Alterações na configuracão do contêiner deve ser manejado com redefinição e reconstrução da imagem do contêiner

---

# Por que nós usaríamos contêiner?

* Maior previsibilidade do estado do ambiente
* Simplificar o processo de mover software entre diferentes ambientes e configurações
* Criar rapidamente ambientes de desenvolvimento
* Evitar _dependency hell_ (ex: múltiplas versões de Java/Ruby)
* Útil para microserviços -- contêiners são menores e mais leves que VMs

---

# Qual é a diferença entre um contêiner e uma VM?

* VMs rodam seu próprio e completo sistema operacional
* Contêiners compartilham o Kernel do sistema operacional do Host
* Contêiners podem inicializar muito mais rápido
* As imagens dos contêiners podem ser muito menores
* Contêiners consumem menos recursos do sistema que uma VM

---

# Qual é a diferença entre um contêiner e uma VM?

.center[![VM vs Container](./imgs/vmVScontainer.png)]

---

class: impact

# O Objetivo

---

# Registro de Votos

* Desenvolvido por Gary Stafford para ajudar a recrutar engenheiros de infraestrutura.
* Uma simples aplicação Java Spring Boot com Mongo DB
* Vamos fazer a execução local do projeto

---

# A Arquitetura da Aplicação

.center[![VM vs Container](./imgs/arquitetura.png)]

---

# A Arquitetura da Aplicação

.center[![VM vs Container](./imgs/arquitetura2.png)]