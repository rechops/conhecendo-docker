title: Treinamento Docker
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

# Lista de afazeres

1. Testar se o docker está corretamente instalado;
2. Executar um contêiner do MongoDB expondo sua porta de conexão;
3. Clonar o repositório da API de votação;
4. (Opcional) Executar localmente a aplicação (requer Java 8 configurado);
5. Escrever um Dockerfile para aplicação que construa o binário e execute a aplicação;
6. Fazer a construção da imagem a partir do Dockerfile;
7. Parar e eliminar o contêiner do MongoDB que foi executado;
8. Executar um novo contêiner do MongoDB sem expor a porta de conexão;
9. Executar o contêiner da aplicação, conectando com o contêiner do MongoDB;
10. Limpar as imagens criadas.

---

# Verifique se Docker está funcionando na sua máquina 

```shell
docker run hello-world
```

---

# Docker run

* O comando `docker run` inicializa um contêiner a partir de uma imagem existente (seja ela local ou de um repositório de Docker)

Utilização:
```shell
docker run [OPÇÕES] IMAGEM [COMANDOS] [ARGUMENTOS...]
```

---

# Executar MongoDB em um contêiner

#### Atividade

2) Executar um contêiner do MongoDB expondo sua porta de conexão;

#### Documentação

https://hub.docker.com/_/mongo

https://github.com/docker-library/mongo/blob/4a81205a13fefc418355248f750551e4f7c62361/3.0/Dockerfile

#### Execução

```shell
docker run -d -p 27017:27017 mongo
docker ps
```

---

# Docker run

```shell
docker run -d -p 27017:27017 --name voter-mongo mongo
```

**-d, --detach**  Executa um contêiner em *background* e imprime o ID do contêiner.

**-p, --publish *hostPort:containerPort*** Publica a(s) porta(s) do contêiner na máquina hospedeira.

**--name** Atribui um nome custom para o contêiner (default gera um random)

---

# Docker ps

* O comando `docker ps` lista todos os contêiners do hospedeiro.

Utilização:
```shell
docker ps
```

---

# Uma nota sobre dockerizar banco de dados

* Tenha bastante cuidado em dockerizar banco de dados
* Docker é normalmente utilizado para aplicações sem estado
* Quando um contêiner para, quaisquer dados armazenados nele são perdidos
* Volumes podem ser montados junto ao Docker para persistir dados

---

# Criando o artefato

#### Atividade

3) Clonar o repositório da API de votação;  
4) (Opcional) Executar localmente a aplicação (requer Java 8 configurado);


```shell
$ git clone --depth 1 --branch master \
  https://github.com/ThoughtWorksInc/voter-service.git

$ cd voter-service

$ ./gradlew clean build -x test

$ java -jar build/libs/voter-service-0.2.0.jar
```
Teste em: http://localhost:8099/candidates

---

# Criando um Dockerfile para a aplicação

#### Atividade

5) Escrever um Dockerfile para aplicação que construa o binário e execute a aplicação;


#### Execução

Crie um arquivo chamado `Dockerfile` com o seguinte conteúdo:

```Dockerfile
FROM openjdk:8u181-jdk
COPY ./voter-service ./usr/local/voter-service
WORKDIR /usr/local/voter-service
RUN ./gradlew clean build -x test
EXPOSE 8099
CMD ["java", "-jar", "build/libs/voter-service-0.2.0.jar", "--spring.data.mongodb.host=voter-mongo"]
```

---

# Dockerfile

O Dockerfile diz para o Docker como criar (e executar) a imagem do seu contêiner.

Palavras-chaves utilizadas:

**FROM** - especifica a imagem base do contêiner  
**RUN** - executa um comando como parte da construção do contêiner  
**COPY** - copia arquivos para dentro do contêiner  
**ENV** - configura uma variável de ambiente  
**EXPOSE** -  documenta uma porta particular para ser exposta pelo contêiner  
**CMD** - específica um comando que será executado quando o `docker run` for realizado  
**WORKDIR** - muda para o diretório informado (igual ao comando `cd`). Se o diretório não existir, ele é criado.

---

# Contruir uma imagem para a aplicação

#### Atividade
6) Fazer a construção da imagem a partir do Dockerfile;

#### Execução

Dentro da pasta onde se encontra o arquivo Dockerfile execute:

```shell
docker build -t voter-registration/web .
```


---
# Docker build

O comando `docker build` constrói uma imagem desde um Dockerfile e um contexto. O contexto da construção é o conjunto de arquivos em um PATH ou URL de local especificado. O PATH é um diretório em seu sistema de arquivos local. O URL é um local do repositório Git.

Utilização:
```shell
docker build [OPÇÕES] PATH | URL | -
```

**-t, --tag *nome:tag***  Nome e opcionalmente uma tag

---
# Eliminar o contêiner MongoDB

#### Atividade

7) Parar e eliminar o contêiner do MongoDB que foi executado;

#### Execução

```shell
docker ps
docker kill voter-mongo
docker ps -a
docker rm voter-mogo
```

---
# Docker kill

Mata um ou mais contêiners que estejam sendo executados

Utilização:
```shell
docker kill CONTAINER ID | NOME
```

---

# Docker ps

```shell
docker ps -a
```

**-a, --all** lista todos containers (Por default, somente mostra os que estão executando)

---

# Docker rm

* Remove um ou mais contêiners

```shell
docker rm CONTAINER ID | NOME
```

---

# MongoDB sem porta de conexão

#### Atividade

8) Executar um novo contêiner do MongoDB sem expor a porta de conexão;

#### Execução

```shell
docker run --rm -d --name voter-mongo mongo
```

---
# Docker run

```shell
docker run --rm -d --name voter-mongo mongo
```
**--rm** Automaticamente remove o contêiner quanto sair.

**-d, --detach**  Executa um contêiner em *background* e imprime o ID do contêiner.

**--name** Atribui um nome custom para o contêiner (default gera um random)

---

# Docker run: conectando as coisas

#### Atividade
9) Executar o contêiner da aplicação, conectando com o contêiner do MongoDB;

#### Execução

```shell
docker run --rm -p 8099:8099 --name voter-registration-web --link voter-mongo:mongo voter-registration/web
```

---

# Docker run

```shell
docker run --rm -p 8099:8099 --name voter-registration-web --link voter-mongo:mongo voter-registration/web
```

**--rm** Automaticamente remove o contêiner quanto sair.

**-p, --publish *hostPort:containerPort*** Publica a(s) porta(s) do contêiner na máquina hospedeira.

**--link _list_(nome:alias)**  Adiciona uma conexão com outros contêiners

Teste em: http://localhost:8099/candidates

---

# Limpando imagem

#### Atividade
10) Limpar as imagens criadas.

#### Execução
Listar todas as imagens locais

```shell
docker images
```

Excluir uma imagem
```shell
docker rmi NOMEDAIMAGEM
```