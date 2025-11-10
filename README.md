<div align="center"><div align="center">



<img src="assets/logo.png" alt="NautiKube Logo" width="800"/><img src="assets/logo.png" alt="NautiKube Logo" width="800"/>



**Diagnóstico inteligente para Kubernetes****Diagnóstico inteligente para Kubernetes**



[![Licença: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow.svg)](https://opensource.org/licenses/MIT)[![Licença: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Versão](https://img.shields.io/badge/vers%C3%A3o-2.0.0-blue.svg)](https://github.com/jorgegabrielti/nautikube/releases)[![Vers�o](https://img.shields.io/badge/vers%C3%A3o-2.0.0-blue.svg)](https://github.com/jorgegabrielti/NautiKube/releases)

[![Go](https://img.shields.io/badge/Go-1.21-00ADD8.svg)](https://golang.org/)[![Go](https://img.shields.io/badge/Go-1.21-00ADD8.svg)](https://golang.org/)



Ferramenta própria de análise de clusters Kubernetes com **IA local**  Ferramenta pr�pria de an�lise de clusters Kubernetes com **IA local**  

Totalmente local • Privado • Performance otimizada • 100% em portuguêsTotalmente local � Privado � Performance otimizada � 100% em portugu�s



[Começar](#-início-rápido) • [Documentação](docs/) • [Contribuir](CONTRIBUTING.md)[Come�ar](#-in�cio-r�pido) � [Documenta��o](docs/) � [Contribuir](CONTRIBUTING.md)



</div></div>



------



## 🎯 O que faz?##  O que faz?



Escaneia seu cluster Kubernetes, identifica problemas e **explica em linguagem simples** usando IA local via Ollama.Escaneia seu cluster Kubernetes, identifica problemas e **explica em linguagem simples** usando IA local via Ollama.



```bash```bash

# Execute uma análise# Execute uma an�lise

docker exec nautikube nautikube analyze --explain --language Portuguesedocker exec NautiKube NautiKube analyze --explain --language Portuguese

``````



**Exemplo de saída:****Exemplo de sa�da:**

``````

🔍 Encontrados 2 problema(s):?? Encontrados 2 problema(s):



0: Pod default/nginx-5d5d5d5d-xxx0: Pod default/nginx-5d5d5d5d-xxx

- Error: Container nginx in CrashLoopBackOff- Error: Container nginx in CrashLoopBackOff

- IA: Este container está reiniciando continuamente. Isso geralmente acontece - IA: Este container est� reiniciando continuamente. Isso geralmente acontece 

  quando o processo principal dentro do container falha. Verifique os logs com   quando o processo principal dentro do container falha. Verifique os logs com 

  'kubectl logs nginx-5d5d5d5d-xxx' para identificar o erro específico.  'kubectl logs nginx-5d5d5d5d-xxx' para identificar o erro espec�fico.

``````



------



## 🚀 Início Rápido##  In�cio R�pido



### Pré-requisitos### Pr�-requisitos

- Docker & Docker Compose- Docker & Docker Compose

- Cluster Kubernetes ativo- Cluster Kubernetes ativo

- ~8GB de espaço livre- ~8GB de espa�o livre



### Instalação### Instala��o



```bash```bash

# 1. Clone o repositório# 1. Clone o reposit�rio

git clone https://github.com/jorgegabrielti/nautikube.gitgit clone https://github.com/jorgegabrielti/NautiKube.git

cd nautikubecd NautiKube



# 2. Inicie os serviços# 2. Inicie os servi�os

docker-compose up -ddocker-compose up -d



# 3. Baixe o modelo de IA (primeira vez - ~4.7GB)# 3. Baixe o modelo de IA (primeira vez - ~4.7GB)

docker exec nautikube-ollama ollama pull llama3.1:8bdocker exec NautiKube-ollama ollama pull llama3.1:8b



# 4. Pronto! Analisar cluster# 4. Pronto! Analisar cluster

docker exec nautikube nautikube analyze --explain --language Portuguesedocker exec NautiKube NautiKube analyze --explain --language Portuguese

``````



> 💡 **Novo!** Não é mais necessário configurar backend. O NautiKube detecta e conecta automaticamente ao Ollama!> ?? **Novo!** N�o � mais necess�rio configurar backend. O NautiKube detecta e conecta automaticamente ao Ollama!



------



## 📋 Comandos Úteis##  Comandos �teis



```bash```bash

# Análise rápida (sem IA)# An�lise r�pida (sem IA)

docker exec nautikube nautikube analyzedocker exec NautiKube NautiKube analyze



# Análise completa em português com explicações da IA# An�lise completa em portugu�s com explica��es da IA

docker exec nautikube nautikube analyze --explain --language Portuguesedocker exec NautiKube NautiKube analyze --explain --language Portuguese



# Análise completa em inglês# An�lise completa em ingl�s

docker exec nautikube nautikube analyze --explain --language Englishdocker exec NautiKube NautiKube analyze --explain --language English



# Analisar namespace específico# Analisar namespace espec�fico

docker exec nautikube nautikube analyze -n kube-system --explain --language Portuguesedocker exec NautiKube NautiKube analyze -n kube-system --explain --language Portuguese



# Filtrar por tipo de recurso# Filtrar por tipo de recurso

docker exec nautikube nautikube analyze --filter Pod --explain --language Portuguesedocker exec NautiKube NautiKube analyze --filter Pod --explain --language Portuguese

docker exec nautikube nautikube analyze --filter ConfigMapdocker exec NautiKube NautiKube analyze --filter ConfigMap



# Ver versão# Ver vers�o

docker exec nautikube nautikube versiondocker exec NautiKube NautiKube version



# Listar modelos Ollama instalados# Listar modelos Ollama instalados

docker exec nautikube-ollama ollama listdocker exec NautiKube-ollama ollama list



# Ver status dos containers# Ver status dos containers

docker-compose psdocker-compose ps

``````



------



## 🤖 Modelos Disponíveis##  Modelos Dispon�veis



| Modelo | Tamanho | Velocidade | Qualidade | Português | Recomendado para || Modelo | Tamanho | Velocidade | Qualidade | Portugu�s | Recomendado para |

|--------|---------|------------|-----------|-----------|------------------||--------|---------|------------|-----------|-----------|------------------|

| **llama3.1:8b** ⭐ | 4.7GB | Bom | Excelente | ⭐⭐⭐⭐⭐ | **Recomendado (PT-BR)** || **llama3.1:8b** ? | 4.7GB | Bom | Excelente | ????? | **Recomendado (PT-BR)** |

| **gemma2:9b** | 5.4GB | Médio | Excelente | ⭐⭐⭐⭐⭐ | Melhor qualidade || **gemma2:9b** | 5.4GB | M�dio | Excelente | ????? | Melhor qualidade |

| **qwen2.5:7b** | 4.7GB | Rápido | Muito Boa | ⭐⭐⭐⭐ | Velocidade || **qwen2.5:7b** | 4.7GB | R�pido | Muito Boa | ???? | Velocidade |

| **mistral** | 4.1GB | Médio | Boa | ⭐⭐⭐ | Uso geral || **mistral** | 4.1GB | M�dio | Boa | ??? | Uso geral |

| **tinyllama** | 1.1GB | Muito Rápido | Básica | ⭐⭐ | Scans rápidos || **tinyllama** | 1.1GB | Muito R�pido | B�sica | ?? | Scans r�pidos |



> 🎯 **llama3.1:8b** é o modelo padrão por oferecer excelente suporte ao português brasileiro> ?? **llama3.1:8b** � o modelo padr�o por oferecer excelente suporte ao portugu�s brasileiro



**Trocar modelo:****Trocar modelo:**

```bash```bash

# Instalar outro modelo no Ollama# Instalar outro modelo no Ollama

docker exec nautikube-ollama ollama pull gemma2:9bdocker exec NautiKube-ollama ollama pull gemma2:9b



# Atualizar variável de ambiente e reiniciar# Atualizar vari�vel de ambiente e reiniciar

# Edite .env e mude OLLAMA_MODEL=gemma2:9b# Edite .env e mude OLLAMA_MODEL=gemma2:9b

docker-compose restart nautikubedocker-compose restart NautiKube

``````



------



## 🎯 Por que NautiKube próprio?##  Por que NautiKube pr�prio?



Desenvolvemos nossa própria solução nativa em Go por diversos motivos:Desenvolvemos nossa pr�pria solu��o nativa em Go por diversos motivos:



| Aspecto | Antes | Agora | Benefício || Aspecto | Antes | Agora | Benef�cio |

|---------|-------|-------|-----------||---------|-------|-------|-----------|

| **Performance** | Startup 30s | Startup <10s | ⚡ 3x mais rápido || **Performance** | Startup 30s | Startup <10s | ? 3x mais r�pido |

| **Tamanho** | ~200MB | ~80MB | 📦 60% menor || **Tamanho** | ~200MB | ~80MB | ?? 60% menor |

| **Configuração** | 3 passos | Automática | 🎯 Plug & play || **Configura��o** | 3 passos | Autom�tica | ?? Plug & play |

| **Código** | Dependência externa | Código próprio | 🔧 Controle total || **C�digo** | Depend�ncia externa | C�digo pr�prio | ?? Controle total |

| **Features** | Limitadas | Customizáveis | 🚀 Expansível || **Features** | Limitadas | Customiz�veis | ?? Expans�vel |

| **Manutenção** | Dependente upstream | Independente | ✅ Autonomia || **Manuten��o** | Dependente upstream | Independente | ? Autonomia |



**Principais vantagens:****Principais vantagens:**

- 🇧🇷 Suporte nativo ao português (não precisa flag --language)- ???? Suporte nativo ao portugu�s (n�o precisa flag --language)

- 🎨 Interface CLI mais simples e direta- ?? Interface CLI mais simples e direta

- ⚡ Detecção automática do Ollama (sem configuração manual)- ? Detec��o autom�tica do Ollama (sem configura��o manual)

- 📊 Performance otimizada para clusters pequenos e médios- ?? Performance otimizada para clusters pequenos e m�dios

- 🔧 Facilidade para adicionar novos tipos de análise- ?? Facilidade para adicionar novos tipos de an�lise



------



## 🔧 Solução de Problemas##  Solu��o de Problemas



**Container não inicia?****Container n�o inicia?**

```bash```bash

docker-compose logs nautikubedocker-compose logs NautiKube

``````



**Ollama não responde?****Ollama n�o responde?**

```bash```bash

docker logs nautikube-ollamadocker logs NautiKube-ollama

docker exec nautikube-ollama ollama listdocker exec NautiKube-ollama ollama list

``````



**NautiKube não acessa o cluster?****NautiKube n�o acessa o cluster?**

```bash```bash

docker exec nautikube kubectl get nodesdocker exec NautiKube kubectl get nodes

docker exec nautikube cat /root/.kube/config_moddocker exec NautiKube cat /root/.kube/config_mod

``````



**Erro "connection refused"?****Erro "connection refused"?**

Certifique-se que seu cluster Kubernetes está rodando:Certifique-se que seu cluster Kubernetes est� rodando:

```bash```bash

kubectl cluster-infokubectl cluster-info

``````



------



## 📚 Documentação##  Documenta��o



- 📖 [Arquitetura](docs/ARCHITECTURE.md) - Como funciona internamente-  [Arquitetura](docs/ARCHITECTURE.md) - Como funciona internamente

- 🔧 [Solução de Problemas](docs/TROUBLESHOOTING.md) - Problemas comuns e soluções-  [Solu��o de Problemas](docs/TROUBLESHOOTING.md) - Problemas comuns e solu��es

- ❓ [Perguntas Frequentes](docs/FAQ.md) - Dúvidas mais comuns-  [Perguntas Frequentes](docs/FAQ.md) - D�vidas mais comuns

- 🤝 [Como Contribuir](CONTRIBUTING.md) - Guia para contribuições-  [Como Contribuir](CONTRIBUTING.md) - Guia para contribui��es



------



## 📄 Licença##  Licen�a



Licença MIT - consulte o arquivo [LICENSE](LICENSE) para mais detalhes.Licen�a MIT - consulte o arquivo [LICENSE](LICENSE) para mais detalhes.



------



## 🙏 Créditos##  Cr�ditos



- [Ollama](https://ollama.ai/) - Plataforma de modelos de linguagem locais- [Ollama](https://ollama.ai/) - Plataforma de modelos de linguagem locais

- [Kubernetes](https://kubernetes.io/) - Sistema de orquestração de contêineres- [Kubernetes](https://kubernetes.io/) - Sistema de orquestra��o de cont�ineres



------

