<div align="center">

#  Mekhanikube

**Seu mecânico de Kubernetes com IA**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/jorgegabrielti/mekhanikube/releases)

Análise inteligente de clusters Kubernetes usando **K8sGPT** + **Ollama**  
Totalmente local  Privado  Fácil de usar

[Começar](#-início-rápido)  [Documentação](docs/)  [Contribuir](CONTRIBUTING.md)

</div>

---

##  O que faz?

Escaneia seu cluster Kubernetes, identifica problemas e **explica em linguagem simples** usando IA local.

```bash
# Execute uma análise
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain
```

**Exemplo de saída:**
```
0: Pod default/nginx-5d5d5d5d-xxx
- Error: CrashLoopBackOff
- IA: Este pod está reiniciando continuamente porque o comando de entrada 
  está falhando. Verifique os logs com kubectl logs e corrija o comando.
```

---

##  Início Rápido

### Pré-requisitos
- Docker & Docker Compose
- Cluster Kubernetes ativo
- ~10GB de espaço livre

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/jorgegabrielti/mekhanikube.git
cd mekhanikube

# 2. Inicie os serviços
docker-compose up -d

# 3. Baixe o modelo de IA (primeira vez - ~5GB)
docker exec mekhanikube-ollama ollama pull gemma:7b

# 4. Analisar cluster
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain
```

---

##  Comandos Úteis

```bash
# Análise completa
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain

# Analisar namespace específico
docker exec mekhanikube-k8sgpt k8sgpt analyze -n kube-system --explain

# Filtrar por tipo (Pod, Service, Deployment, etc)
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Pod --explain

# Listar modelos instalados
docker exec mekhanikube-ollama ollama list

# Ver status dos containers
docker-compose ps
```

---

##  Modelos Disponíveis

| Modelo | Tamanho | Velocidade | Qualidade | Recomendado para |
|--------|---------|------------|-----------|------------------|
| **gemma:7b** | 4.8GB | Médio | Boa | Uso geral  |
| **mistral** | 4.1GB | Médio | Boa | Explicações detalhadas |
| **tinyllama** | 1.1GB | Rápido | Básica | Scans rápidos |
| **llama2:13b** | 7.4GB | Lento | Excelente | Melhor qualidade |

**Trocar modelo:**
```bash
# Instalar outro modelo
docker exec mekhanikube-ollama ollama pull mistral

# Reconfigurar K8sGPT
docker exec mekhanikube-k8sgpt k8sgpt auth remove --backend ollama
docker exec mekhanikube-k8sgpt k8sgpt auth add --backend ollama --model mistral --baseurl http://localhost:11434
docker exec mekhanikube-k8sgpt k8sgpt auth default -p ollama
```

---

##  Solução de Problemas

**Container não inicia?**
```bash
docker-compose logs
```

**Ollama não responde?**
```bash
docker logs mekhanikube-ollama
docker exec mekhanikube-ollama ollama list
```

**K8sGPT não acessa o cluster?**
```bash
docker exec mekhanikube-k8sgpt kubectl get nodes
docker exec mekhanikube-k8sgpt cat /root/.kube/config_mod
```

---

##  Documentação

-  [Arquitetura](docs/ARCHITECTURE.md) - Como funciona
-  [Troubleshooting](docs/TROUBLESHOOTING.md) - Problemas comuns
-  [FAQ](docs/FAQ.md) - Perguntas frequentes
-  [Contribuindo](CONTRIBUTING.md) - Como contribuir

---

##  Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

---

##  Créditos

- [K8sGPT](https://github.com/k8sgpt-ai/k8sgpt) - Análise de Kubernetes
- [Ollama](https://ollama.ai/) - LLM local

---

<div align="center">

**Feito com  para a comunidade Kubernetes**

</div>
