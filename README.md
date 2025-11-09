# Mekhanikube 🔧

**Your Kubernetes AI Mechanic**

Análise inteligente de clusters Kubernetes usando K8sGPT com IA local (Ollama). Diagnostica problemas, explica causas e sugere soluções automaticamente.

## 🚀 Quick Start

```powershell
# 1. Subir os serviços (Ollama + K8sGPT)
docker-compose up -d

# 2. Aguardar containers iniciarem
Start-Sleep -Seconds 5

# 3. Baixar o modelo Gemma (apenas primeira vez - ~5GB)
docker exec mekhanikube-ollama ollama pull gemma:7b

# 4. Analisar cluster com explicações da IA (configuração é automática!)
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain
```

## 📋 Comandos K8sGPT

```powershell
# Analisar cluster (sem IA)
docker exec mekhanikube-k8sgpt k8sgpt analyze

# Analisar com explicações da IA
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain

# Analisar namespace específico
docker exec mekhanikube-k8sgpt k8sgpt analyze -n kube-system --explain

# Filtrar por tipo de recurso
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Pod --explain
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Service --explain

# Listar filtros disponíveis
docker exec mekhanikube-k8sgpt k8sgpt filters list

# Verificar configuração
docker exec mekhanikube-k8sgpt k8sgpt auth list
```

## 🛠️ Configuração

### Modelos Ollama Recomendados

```powershell
# Gemma 7B (recomendado - boa qualidade)
docker exec mekhanikube-ollama ollama pull gemma:7b

# Mistral (alternativa)
docker exec mekhanikube-ollama ollama pull mistral

# TinyLlama (mais rápido, qualidade inferior)
docker exec mekhanikube-ollama ollama pull tinyllama
```

### Trocar modelo

```powershell
# Remover backend atual
docker exec mekhanikube-k8sgpt k8sgpt auth remove --backend localai

# Adicionar com novo modelo
docker exec mekhanikube-k8sgpt k8sgpt auth add --backend localai --model mistral --baseurl http://localhost:11434/v1
docker exec mekhanikube-k8sgpt k8sgpt auth default -p localai
```

## 📊 Arquitetura

```
┌─────────────────┐
│   Kubernetes    │
│     Cluster     │
│   (em VM/Host)  │
└────────┬────────┘
         │ kubeconfig (montado em /root/.kube/)
         │
    ┌────▼──────────────┐
    │  k8sgpt container │
    │  - Ajusta config  │
    │    automaticamente│
    │  - Roda análises  │
    └────────┬──────────┘
             │ API calls (http://localhost:11434/v1)
             │
    ┌────────▼──────────┐
    │ ollama container  │
    │  - Gemma:7b model │
    │  - Gera explicações│
    └───────────────────┘
```

## 🔧 Troubleshooting

### K8sGPT não consegue acessar cluster

```powershell
# Verificar se kubeconfig está montado
docker exec mekhanikube-k8sgpt ls -la /root/.kube/

# Verificar se config_mod foi criado pelo entrypoint
docker exec mekhanikube-k8sgpt cat /root/.kube/config_mod

# Testar conexão manual
docker exec mekhanikube-k8sgpt kubectl get nodes
```

### Ollama não responde

```powershell
# Ver logs
docker logs mekhanikube-ollama

# Verificar modelos instalados
docker exec mekhanikube-ollama ollama list

# Testar API
Invoke-RestMethod -Uri http://localhost:11434/v1/models | ConvertTo-Json

# Baixar modelo novamente
docker exec mekhanikube-ollama ollama pull gemma:7b
```

### Container k8sgpt não inicia

```powershell
# Ver logs
docker logs mekhanikube-k8sgpt

# Reconstruir imagem
docker-compose build k8sgpt
docker-compose up -d k8sgpt
```

## 📚 Recursos

- [K8sGPT Docs](https://docs.k8sgpt.ai/)
- [Ollama Models](https://ollama.com/library)
- [K8sGPT GitHub](https://github.com/k8sgpt-ai/k8sgpt)

## 🔍 Como Funciona

1. **Entrypoint automático**: O container k8sgpt executa `/entrypoint.sh` ao iniciar, que:
   - Copia o kubeconfig montado de `/root/.kube/config`
   - Substitui `127.0.0.1` por `host.docker.internal` para acessar o cluster na VM/Host
   - Salva em `/root/.kube/config_mod`
   - Define `KUBECONFIG=/root/.kube/config_mod`

2. **Análise**: K8sGPT escaneia o cluster e identifica problemas (ConfigMaps não usados, Pods com erro, etc)

3. **Explicação**: Quando usa `--explain`, K8sGPT envia o problema para Ollama via API REST

4. **Resposta**: Ollama processa com o modelo gemma:7b e retorna explicação + solução



Se você já tem Ollama rodando:export OLLAMA_MODEL=mistral



```powershell```2. Inicie o Ollama:

# O programa detecta automaticamente

.\kube-ai.exe```bash

```

## Usodocker-compose up -d

**Nota:** Ollama é significativamente mais lento (1-2 minutos por scan).

```

---

```bash

## 🔧 Configuração Avançada

# Iniciar chat interativo3. Instale o modelo Mistral:

### Variáveis de Ambiente

./kube-ai```bash

```powershell

# Forçar uso de LocalAIdocker exec -it ollama ollama pull mistral

$env:LLM_PROVIDER="localai"

$env:LOCALAI_URL="http://localhost:8080"# Comandos disponíveis:```

$env:LOCALAI_MODEL="phi-2"

# scan    - Escanear cluster em busca de problemas

# Forçar uso de Ollama

$env:LLM_PROVIDER="ollama"# exit    - Sair do chat4. Compile e instale a CLI:

$env:OLLAMA_URL="http://localhost:11434"

$env:OLLAMA_MODEL="mistral"# qualquer texto - Fazer perguntas sobre Kubernetes```bash

```

```go install ./cmd/kube-ai

---

```

## 📊 Comparação de Performance

## Exemplos

| Provider | Modelo    | Tempo/Scan | Qualidade | RAM   |

|----------|-----------|------------|-----------|-------|## Uso

| LocalAI  | phi-2     | ~5-10s     | ⭐⭐⭐⭐    | 2GB   |

| Ollama   | mistral   | ~60-120s   | ⭐⭐⭐⭐⭐  | 4GB   |```

| Ollama   | tinyllama | ~30-60s    | ⭐⭐⭐     | 2GB   |

> scanSimplesmente execute:

**Recomendação:** Use LocalAI com phi-2 para melhor balance entre velocidade e qualidade.

🔍 Escaneando cluster...```bash

---

🤖 Analisando 2 problemas encontrados...kube-ai

## 🛠️ Troubleshooting

```

### LocalAI não inicia

> O que é um CrashLoopBackOff?

```powershell

# Verifique se o modelo foi baixado🤖 CrashLoopBackOff indica que um container está falhando...A ferramenta irá:

dir .\models\

1. Conectar ao seu cluster Kubernetes

# Verifique logs do container

docker-compose logs localai> Como debugar um pod?2. Procurar por pods com problemas



# Reinicie o serviço🤖 Use kubectl describe pod <name> para ver eventos...3. Coletar informações detalhadas

docker-compose restart

``````4. Usar IA local para analisar e sugerir soluções



### Scan muito lento

Se nenhum problema for encontrado, você verá:

- ✅ **Solução:** Use LocalAI em vez de Ollama```

- Execute: `.\download-model.ps1` e `docker-compose up -d`✅ Cluster saudável

```

### Erro de conexão com Kubernetes

Se problemas forem encontrados, você receberá uma análise detalhada com:

```powershell- Causa provável do problema

# Verifique se o cluster está acessível- Como resolver o problema

kubectl cluster-info- Como prevenir que aconteça novamente

go mod init kube-ai

# Verifique o contexto atualgo get k8s.io/client-go

kubectl config current-contextgo build -o kube-ai ./cmd/kube-ai

``````



---## Uso



## 📦 Requisitos```bash

./kube-ai

- **Go:** 1.21 ou superior```

- **Docker Desktop:** Com Kubernetes habilitado

- **RAM:** 4GB disponível## Estrutura do Projeto

- **Disco:** 2GB para modelo Phi-2

```

---kube-ai/

 ├── cmd/

## 🏗️ Arquitetura │    └── kube-ai/        # main.go, parsing de comandos CLI

 ├── internal/

``` │    ├── k8s/            # conexão + scanner

kube-ai/ │    │    ├── connect.go

├── cmd/kube-ai/          # CLI principal │    │    └── scan.go

├── internal/ │    ├── llm/            # integração com ollama

│   ├── k8s/             # Cliente Kubernetes │    │    └── ollama.go

│   └── llm/             # Cliente LLM (LocalAI/Ollama) │    └── explain/        # heurísticas e montagem de prompts

├── models/              # Modelos de IA │         └── explain.go

├── docker-compose.yml   # LocalAI setup ├── go.mod

└── download-model.ps1   # Script para baixar Phi-2 └── README.md

``````

---

## 📝 Licença

MIT


