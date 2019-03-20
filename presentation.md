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

# O que é um Container?

* Permite você definir e empacotar um ambiente de execução dentro de uma imagem executável.

* Essa image pode conter:
  * Binários de uma aplicação
  * Configurações para uma aplicação
  * Todas as suas dependências
  * Configurações de sistema (arquivos, diretórios, variáveis de ambiente, etc.)

---

# O que é um Container?

* Utiliza o sistema operacional para **isolar** o processo, rede e sistema de arquivo do Container para que aparente que seja um ambiente de servidor auto-contido

* Containers devem ser pensados como sendo **imutáveis**
 * Alterações na configuracão do Container deve ser manejado com redefinição e reconstrução da imagem do Container

---