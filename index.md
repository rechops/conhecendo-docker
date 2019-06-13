title: Conhecendo Docker na Prática
class: animation-fade
layout: true

<!-- This slide will serve as the base layout for all your slides -->
.bottom-bar[
  {{title}}
]

---

class: impact

# {{title}}
## by Rodrigo Rech

---

# Katacoda Time
.center[![Katacoda Logo](./imgs/katacoda-1.png)]
Antes de começarmos, acesse [este link](https://www.katacoda.com/rodrigorech/scenarios/docker-na-pratica) e deixe o Katacoda configurar o ambiente.

---

# O que é uma máquina virtual?

- Máquinas virtuais (VMs) são uma **abstração de hardware físico**, transformando um servidor em vários servidores.
- O hypervisor permite que várias VMs sejam executadas em uma única máquina.
- Cada VM inclui **uma cópia completa de um sistema operacional**, o aplicativo, binários necessários e bibliotecas - ocupando dezenas de GBs.
- As VMs também podem ser lentas para inicializar."_

Fonte: https://www.docker.com/resources/what-container

---

# O que é um contêiner?

- Os contêineres são uma **abstração na camada de aplicação** que agrupa código e dependências.
- Um contêiner é uma **instância de tempo de execução** de uma imagem Docker.
- Vários contêineres podem ser executados na mesma máquina e **compartilhar o kernel** do sistema operacional com outros contêineres, cada um sendo executado como **processos isolados** no espaço do usuário.
- Os contêineres ocupam menos espaço que as VMs (as imagens de contêiner geralmente têm dezenas/centenas de MBs), podem lidar com mais aplicativos e exigem menos VMs e sistemas operacionais._

Fonte: https://www.docker.com/resources/what-container
---

# Qual é a diferença entre uma Máquina Virtual e um contêiner?

.inline-block.left[![VM vs Container](./imgs/docker-containerized.png)]
.inline-block.right[![VM vs Container](./imgs/container-vm.png)]


Fonte: https://www.docker.com/resources/what-container

---

# O que é uma imagem?

* Permite você definir e empacotar um ambiente de execução.

* Essa image pode conter:
  * Binários de uma aplicação
  * Configurações para uma aplicação
  * Todas as suas dependências
  * Configurações de sistema (arquivos, diretórios, variáveis de ambiente, etc.)

---

# Por que nós usaríamos contêiner?

* Maior previsibilidade do estado do ambiente
* Simplificar o processo de mover software entre diferentes ambientes e configurações
* Criar rapidamente ambientes de desenvolvimento
* Evitar _dependency hell_ (ex: múltiplas versões de Java/Ruby)
* Útil para microserviços -- contêiners são menores e mais leves que VMs
* Viabiliza a prática de entrega contínua;
* Permite configurar quantidade de recursos consumidos do hardware (CPU e Memória);

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

---

class: impact

# Ao trabalho...

---

# Katacoda Time
.center[![Katacoda Logo](./imgs/katacoda-1.png)]
Se você ainda não abriu o exercício, acesse [este link](https://www.katacoda.com/rodrigorech/scenarios/docker-na-pratica) e siga as instruções.

---
class: impact

# Docker Registry

---

# Docker Registry ([Docker Hub](https://hub.docker.com/))

## O que é?

O Registry é uma aplicação sem estado, altamente escalável que armazena e permite distribuir imagens do Docker.

## Por que usá-lo

Você deve usar o Registry se quiser:

- controlar rigorosamente onde suas imagens estão sendo armazenadas;
- controlar a distribuição das suas imagens;
- integrar armazenamento e distribuição em fluxo de desenvolvimento;

---

# Comandos Básicos

### [Login](https://docs.docker.com/engine/reference/commandline/login/)

```shell
docker login [OPÇÕES] [SERVIDOR]
```


### [Puxar](https://docs.docker.com/engine/reference/commandline/pull/) uma imagem do registry

```shell
docker pull [OPÇÕES] NOME[:TAG]
```

### [Empurrar](https://docs.docker.com/engine/reference/commandline/push/) uma imagem para o registry

```shell
docker push [OPÇÕES] NOME[:TAG]
```

---
class: impact

# Boas práticas

---

# Compilação em múltiplas etapas

```Dockerfile
FROM openjdk:8u181-jdk AS builder
COPY ./voter-service ./usr/local/voter-service
WORKDIR /usr/local/voter-service
RUN ./gradlew clean build -x test

FROM openjdk:8u201-jre-alpine3.9
COPY --from=builder /usr/local/voter-service/build/libs/voter-service-0.2.0.jar .
EXPOSE 8099
CMD ["java", "-jar", "./voter-service-0.2.0.jar", "--spring.data.mongodb.host=voter-mongo"]
```

---

# Guarde configurações no ambiente

* [Príncipio 3 do Twelve-Factor App](https://12factor.net/config)

```Dockerfile
FROM openjdk:8u181-jdk AS builder
COPY ./voter-service ./usr/local/voter-service
WORKDIR /usr/local/voter-service
RUN ./gradlew clean build -x test

FROM openjdk:8u201-jre-alpine3.9
COPY --from=builder /usr/local/voter-service/build/libs/voter-service-0.2.0.jar .
ENV MONGODB_HOST voter-mongo
EXPOSE 8099
CMD ["sh", "-c", "java -jar ./voter-service-0.2.0.jar --spring.data.mongodb.host=$MONGODB_HOST"]
```

---

# Configurações no ambiente + Compilação em múltiplas etapas

#### Execução

```shell
docker build -t voter-registration/web .
docker image inspect voter-registration/web:env
docker kill voter-mongo
docker run --rm -d --name mongodb mongo
docker run --rm -p 8099:8099 --env MONGODB_HOST=mongodb --name voter-registration-web --link mongodb:mongo voter-registration/web:env
```

#### Teste
http://localhost:8099/votes

---

class: impact

# OBRIGADO!
## <3
