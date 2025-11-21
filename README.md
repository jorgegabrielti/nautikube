<div align="center">

<img src="assets/logo.png" alt="NautiKube Logo" width="800"/>

**Diagnóstico inteligente para o seu Cluster Kubernetes com priorização automática**

[![Licença: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Versão](https://img.shields.io/badge/vers%C3%A3o-0.9.1-orange.svg?cacheSeconds=0)](https://github.com/jorgegabrielti/nautikube/releases)
[![Go](https://img.shields.io/badge/Go-1.21-00ADD8.svg)](https://golang.org/)
[![Testes](https://img.shields.io/badge/testes-33%20passing-brightgreen.svg)](https://github.com/jorgegabrielti/nautikube)

> 🚀 **v0.9.1 - Beta Funcional:** Sistema de severidade e score implementado! Todas as funcionalidades funcionam. Roadmap claro para **v1.0.0 (Fev/2026)**.

**Ferramenta de análise inteligente de clusters Kubernetes com IA local**  
🎯 Priorização automática • 🔴 Severidade visual • 📊 Score contextual • 🇧🇷 100% português • 🔒 Totalmente privado

[Começar](#-início-rápido) • [Documentação](docs/) • [Roadmap](#-roadmap) • [Contribuir](CONTRIBUTING.md)

</div>

---

## ✨ Novidades v0.9.1

### 🎯 Sistema de Severidade e Score
Problemas agora são classificados automaticamente por prioridade:

- **🔴 CRITICAL** (Score: 90-100): CrashLoopBackOff, OOMKilled, Pods críticos com falha
- **🟠 HIGH** (Score: 70-89): ImagePullBackOff, restarts elevados, erros de configuração
- **🟡 MEDIUM** (Score: 50-69): Warnings, restarts moderados
- **🔵 LOW** (Score: 30-49): Avisos de linting, otimizações sugeridas
- **⚪ INFO** (Score: 0-29): Informações gerais

**Score Inteligente Contextual:**
- Ajuste automático +10 para namespaces críticos (`kube-system`, `default`)
- Ajuste automático +10 para problemas críticos de Pod
- Ajuste automático +10 para Services sem endpoints
- Cap máximo: 100 pontos

---

##  O que faz?

Escaneia seu cluster Kubernetes, **identifica e prioriza problemas automaticamente**, e explica em linguagem simples usando IA local via Ollama.

```bash
# Execute uma análise com priorização
docker exec nautikube nautikube analyze --explain
```

**Exemplo de saída:**
```
🔍 Encontrados 3 problema(s):

🔴 [CRITICAL] Score: 100/100
Pod default/nginx-deployment-xxx
- Error: Container nginx in CrashLoopBackOff
- IA: Este container está reiniciando continuamente. Isso geralmente acontece 
  quando o processo principal dentro do container falha. Verifique os logs com 
  'kubectl logs nginx-deployment-xxx' para identificar o erro específico.

🟠 [HIGH] Score: 80/100
Pod kube-system/coredns-xxx
- Error: ImagePullBackOff
- IA: O Kubernetes não consegue baixar a imagem do container. Verifique se a 
  imagem existe no registry e se as credenciais estão corretas.
```

---

## 🚀 Início Rápido

### Pré-requisitos
- Docker & Docker Compose
- Cluster Kubernetes ativo (qualquer tipo - veja suporte abaixo)
- ~8GB de espaço livre (para modelos IA)
- kubeconfig configurado em `~/.kube/config`

### 🎯 Clusters Suportados
✅ **Local:** Docker Desktop • Kind • Minikube • k3d • MicroK8s  
✅ **Cloud:** AWS EKS • Azure AKS • Google GKE  
✅ **Enterprise:** Bare-metal • Kubeadm • OpenShift • Rancher  
✅ **Qualquer distribuição Kubernetes padrão**

> 🎯 **Conexão 100% Agnóstica** - Detecta e configura automaticamente qualquer tipo de cluster!  
> 📖 [Saiba mais sobre conexão agnóstica](docs/AGNOSTIC-CONNECTION.md)

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/jorgegabrielti/nautikube.git
cd nautikube

# 2. Inicie os containers
docker-compose up -d

# 3. Baixe o modelo IA (primeira vez, ~5 minutos)
docker exec nautikube-ollama ollama pull llama3.1:8b

# 4. Analise seu cluster com priorização automática!
docker exec nautikube nautikube analyze --explain
```

**❌ Erro de certificado ao baixar modelo?**  
👉 Você está atrás de proxy corporativo. [Solução rápida aqui](docs/CORPORATE-ENVIRONMENT.md)

> 💡 **v0.9.1:** Detecção automática de severidade e score contextual - priorize o que realmente importa!

---

## 🎁 Features Principais

### ✅ Implementadas (v0.9.1)
- 🔴 **Sistema de Severidade**: 5 níveis (CRITICAL, HIGH, MEDIUM, LOW, INFO)
- 📊 **Score Contextual**: 0-100 pontos com ajustes inteligentes
- 🔍 **Scanner de Pods**: Detecção de CrashLoopBackOff, ImagePullBackOff, OOMKilled
- 🎯 **Análise Inteligente**: Detecção automática de estados de container
- 🤖 **IA Local**: Explicações em português via Ollama
- 🌐 **Conexão Agnóstica**: Funciona com qualquer tipo de cluster
- 📝 **Testes Completos**: 33 testes (28 unitários + 5 integração)

### 🔄 Em Desenvolvimento (Sprint 1)
- 📤 **Exportação JSON**: Integração com outras ferramentas
- 📄 **Exportação YAML**: Formato Kubernetes-native
- 🚀 **Scanner de Deployments**: Análise de estratégias de deploy

### 🎯 Próximas Releases
- **Sprint 2**: Scanner de Services, Filtros por Severidade, ConfigMaps/Secrets
- **Sprint 3**: Análise Comparativa, StatefulSets, Relatórios HTML
- **Sprint 4**: DaemonSets, Detecção de Anomalias, CI/CD Integration

---

## 📋 Comandos Principais

```bash
# Análise completa com priorização e explicações IA (recomendado)
docker exec nautikube nautikube analyze --explain

# Análise rápida com severidade e score (sem IA)
docker exec nautikube nautikube analyze

# Analisar namespace específico
docker exec nautikube nautikube analyze -n kube-system --explain

# Filtrar por tipo de recurso
docker exec nautikube nautikube analyze --filter Pod --explain
docker exec nautikube nautikube analyze --filter ConfigMap

# Filtrar por severidade mínima (em breve)
# docker exec nautikube nautikube analyze --min-severity HIGH

# Ver versão e informações
docker exec nautikube nautikube version

# Listar modelos Ollama instalados
docker exec nautikube-ollama ollama list

# Ver status dos containers
docker-compose ps
```

---

##  Modelos Disponíveis

| Modelo | Tamanho | Velocidade | Qualidade | Português | Recomendado para |
|--------|---------|------------|-----------|-----------|------------------|
| **llama3.1:8b** ⭐ | 4.7GB | Bom | Excelente | ⭐⭐⭐⭐⭐ | **Recomendado (PT-BR)** |
| **gemma2:9b** | 5.4GB | Médio | Excelente | ⭐⭐⭐⭐⭐ | Melhor qualidade |
| **qwen2.5:7b** | 4.7GB | Rápido | Muito Boa | ⭐⭐⭐⭐ | Velocidade |
| **mistral** | 4.1GB | Médio | Boa | ⭐⭐⭐ | Uso geral |
| **tinyllama** | 1.1GB | Muito Rápido | Básica | ⭐⭐ | Scans rápidos |

> 💡 **llama3.1:8b** é o modelo padrão por oferecer excelente suporte ao português brasileiro

**Trocar modelo:**
```bash
# Instalar outro modelo no Ollama
docker exec nautikube-ollama ollama pull gemma2:9b

# Atualizar variável de ambiente e reiniciar
# Edite .env e mude OLLAMA_MODEL=gemma2:9b
docker-compose restart nautikube
```

---

## 🎯 Por que Nautikube?

### Solução Nativa em Go com Foco em Produtividade

| Aspecto | Outras Ferramentas | Nautikube | Benefício |
|---------|-------------------|-----------|-----------|
| **Priorização** | Manual | Automática (Score 0-100) | 🎯 Foco no crítico |
| **Severidade** | Genérica | 5 níveis com ícones | 🔴 Visual instantâneo |
| **Performance** | ~30s startup | <10s startup | ⚡ 3x mais rápido |
| **Configuração** | Múltiplos passos | Plug & play | 🚀 Zero config |
| **IA Local** | Não/Cloud | Ollama integrado | 🔒 100% privado |
| **Português** | Básico/Traduzido | Nativo PT-BR | 🇧🇷 Explicações claras |

### ✨ Principais Diferenciais

**🎯 Priorização Inteligente (v0.9.1+)**
- Sistema de severidade automático (CRITICAL → INFO)
- Score contextual 0-100 com ajustes inteligentes
- Foco visual imediato no que importa

**🔒 Privacidade Total**
- IA local via Ollama (sem enviar dados para cloud)
- Análises 100% dentro do seu ambiente
- Sem telemetria ou tracking

**⚡ Performance Otimizada**
- Binário Go nativo (~80MB)
- Conexão agnóstica a qualquer cluster
- Detecção automática de contexto Kubernetes

**🇧🇷 Experiência em Português**
- Explicações naturais e claras da IA
- Documentação completa em PT-BR
- Comunidade brasileira ativa

**🚀 Desenvolvimento Ativo**
- Workflow profissional de 9 etapas
- Sprint-based com roadmap claro
- Releases frequentes e documentadas

---

##  Solução de Problemas

**Container não inicia?**
```bash
docker-compose logs nautikube
```

**Ollama não responde?**
```bash
docker logs nautikube-ollama
docker exec nautikube-ollama ollama list
```

**nautikube não acessa o cluster?**
```bash
docker exec nautikube kubectl get nodes
docker exec nautikube cat /root/.kube/config_mod
```

**Erro "connection refused"?**
Certifique-se que seu cluster Kubernetes está rodando:
```bash
kubectl cluster-info
```

**Erro "invalid volume specification" no Mac/Linux?**
O docker-compose agora usa `${HOME}/.kube/config` que funciona em todos os sistemas operacionais.
Se seu kubeconfig está em outro local, crie um arquivo `.env`:
```bash
# .env
HOME=/seu/caminho/customizado
```

---

## 🗺️ Roadmap

### v0.9.x - Sprint 1 (Em Andamento - Nov/Dez 2025)
- ✅ **v0.9.1**: Sistema de Severidade e Score (CONCLUÍDO)
- 🔄 **v0.9.2**: Exportação JSON
- 🔄 **v0.9.3**: Exportação YAML
- 🔄 **v0.9.4**: Scanner de Deployments

### Sprint 2 (Dez 2025)
- **v0.9.5**: Scanner de Services
- **v0.9.6**: Filtros por Severidade (--min-severity, --threshold)
- **v0.9.7**: Scanner de ConfigMaps/Secrets
- **v0.9.8**: Histórico de Análises

### Sprint 3 (Jan 2026)
- **v0.9.9**: Análise Comparativa entre Scans
- **v0.9.10**: Scanner de StatefulSets
- **v0.9.11**: Relatórios HTML
- **v0.9.12**: Dashboard Web Básico

### Sprint 4 (Jan 2026)
- **v0.9.13**: Scanner de DaemonSets
- **v0.9.14**: Detecção de Anomalias
- **v0.9.15**: Recomendações de Otimização
- **v0.9.16**: Integração CI/CD

### 🎯 v1.0.0 - Release Stable (Fev 10, 2026)
- Arquitetura CLI-First consolidada
- Multi-provider IA (Ollama, OpenAI, Anthropic, Gemini)
- Documentação completa
- Cobertura de testes >90%
- Todas as features core implementadas

> 📊 **Progresso**: 3 SP de 52 SP totais (5.7%) | **Tempo**: 1h/dia, 5 dias/semana

---

##  Documentação

-  [Arquitetura](docs/ARCHITECTURE.md) - Como funciona internamente
-  [Workflow de Desenvolvimento](docs/DEVELOPMENT-WORKFLOW.md) - Processo profissional de 9 etapas
-  [Solução de Problemas](docs/TROUBLESHOOTING.md) - Problemas comuns e soluções
-  [Perguntas Frequentes](docs/FAQ.md) - Dúvidas mais comuns
-  [Como Contribuir](CONTRIBUTING.md) - Guia para contribuições

---

##  Licença

Licença MIT - consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

##  Créditos

- [Ollama](https://ollama.ai/) - Plataforma de modelos de linguagem locais
- [Kubernetes](https://kubernetes.io/) - Sistema de orquestração de contêineres

---
