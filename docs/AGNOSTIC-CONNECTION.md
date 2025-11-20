# Conexão Agnóstica e Transparente com Clusters Kubernetes

## 📋 Visão Geral

A partir da versão 2.0.3, o NautiKube implementa uma abordagem **100% agnóstica e transparente** para conexão com qualquer tipo de cluster Kubernetes, eliminando a necessidade de configuração manual.

## 🎯 Objetivo

Garantir que o NautiKube funcione **out-of-the-box** com qualquer distribuição ou provedor de Kubernetes, sem exigir conhecimento técnico avançado do usuário sobre configurações de rede, certificados ou autenticação.

## 🔍 Tipos de Clusters Suportados

### Clusters Locais
- **Docker Desktop Kubernetes** ✅
- **Kind** (Kubernetes in Docker) ✅
- **Minikube** ✅
- **k3d** ✅
- **MicroK8s** ✅

### Clusters em Cloud
- **AWS EKS** (Elastic Kubernetes Service) ✅
- **Azure AKS** (Azure Kubernetes Service) ✅
- **Google GKE** (Google Kubernetes Engine) ✅
- **DigitalOcean Kubernetes** ✅
- **Linode Kubernetes Engine** ✅

### Clusters Customizados
- **Bare-metal** (on-premises) ✅
- **Kubeadm clusters** ✅
- **OpenShift** ✅
- **Rancher** ✅
- Qualquer distribuição Kubernetes padrão ✅

## 🚀 Como Funciona

### 1. Detecção Inteligente no Entrypoint

O script `entrypoint-nautikube.sh` analisa o kubeconfig e detecta automaticamente o tipo de cluster baseado na URL do servidor:

```bash
# Exemplo de detecção
https://127.0.0.1:6443        → Cluster Local (Kind/Minikube/Docker Desktop)
https://xxx.eks.amazonaws.com → AWS EKS
https://xxx.azmk8s.io         → Azure AKS
https://xxx.pkg.dev           → Google GKE
https://xxx:6443              → Cluster Customizado
```

### 2. Ajustes Automáticos por Tipo

#### Clusters Locais
```bash
# Problema: localhost/127.0.0.1 não é acessível dentro do container
# Solução: Substitui por host.docker.internal

Antes: https://127.0.0.1:6443
Depois: https://host.docker.internal:6443

# Certificados TLS
- Mantém CA se presente (tenta validação completa)
- Fallback para insecure-skip-tls-verify se necessário
```

#### Clusters em Cloud (EKS/AKS/GKE)
```bash
# Nenhum ajuste necessário
# Usa autenticação nativa via CLI (aws/az/gcloud)
# Kubeconfig mantido original
```

#### Clusters Customizados
```bash
# Assume configuração já está correta
# Mantém kubeconfig como está
# Confia na configuração do usuário
```

### 3. Múltiplas Estratégias de Conexão (Go)

O código Go tenta 4 estratégias em ordem de prioridade:

```go
// 1. In-cluster config (quando rodando dentro do cluster)
config, err := rest.InClusterConfig()

// 2. Kubeconfig modificado pelo entrypoint (Docker)
config, err := clientcmd.BuildConfigFromFlags("", "/root/.kube/config_mod")

// 3. Kubeconfig padrão do sistema
config, err := clientcmd.BuildConfigFromFlags("", "~/.kube/config")

// 4. Variável de ambiente KUBECONFIG
config, err := clientcmd.BuildConfigFromFlags("", os.Getenv("KUBECONFIG"))
```

### 4. Verificação Inteligente de Conectividade

```bash
# Tentativa 1: Conexão direta
kubectl cluster-info

# Tentativa 2: Se falhar, adiciona insecure-skip-tls-verify
# Remove certificate-authority-data que pode estar causando problemas
# Tenta novamente

# Se ainda falhar: Mostra dicas de troubleshooting específicas
```

## 💡 Benefícios

### Para Usuários
- ✅ **Zero configuração** - apenas monte o kubeconfig
- ✅ **Funciona em qualquer ambiente** - dev, staging, produção
- ✅ **Mensagens claras** - mostra exatamente o que está sendo feito
- ✅ **Troubleshooting automático** - tenta resolver problemas sozinho

### Para DevOps
- ✅ **Não precisa entender Docker networking**
- ✅ **Não precisa ajustar certificados manualmente**
- ✅ **Funciona com qualquer provedor de cloud**
- ✅ **Compatível com pipelines CI/CD**

### Para SREs
- ✅ **Transparente e previsível**
- ✅ **Logs detalhados de detecção**
- ✅ **Múltiplos fallbacks**
- ✅ **Seguro por padrão** (tenta validar certificados primeiro)

## 🔧 Configuração de Timeout e Performance

O cliente Go é otimizado com:

```go
config.Timeout = 30 * time.Second  // 30 segundos para operações
config.QPS = 50                     // 50 requisições por segundo
config.Burst = 100                  // Burst de 100 requisições
```

Isso garante:
- ⚡ Respostas rápidas mesmo em clusters grandes
- 🔄 Tolerância a latência de rede
- 📊 Capacidade de listar muitos recursos simultaneamente

## 📊 Fluxo de Detecção

```
┌─────────────────────────────────────────────────────────┐
│  1. Container inicia                                    │
│     ↓                                                   │
│  2. Lê /root/.kube/config                              │
│     ↓                                                   │
│  3. Extrai SERVER_URL                                   │
│     ↓                                                   │
│  4. Detecta tipo baseado em padrão da URL              │
│     ↓                                                   │
│  5. Aplica ajustes específicos                         │
│     ├─ Local: host.docker.internal + TLS               │
│     ├─ Cloud: mantém original                          │
│     └─ Custom: mantém original                         │
│     ↓                                                   │
│  6. Cria /root/.kube/config_mod                        │
│     ↓                                                   │
│  7. Testa conectividade                                │
│     ├─ Sucesso: ✅ Pronto!                             │
│     └─ Falha: Tenta insecure-skip-tls-verify          │
│          ├─ Sucesso: ✅ Conectado                      │
│          └─ Falha: ❌ Mostra troubleshooting          │
└─────────────────────────────────────────────────────────┘
```

## 🧪 Exemplos de Uso

### Exemplo 1: Docker Desktop
```bash
# Usuário apenas executa
docker-compose up -d

# Saída do container:
⚓ NautiKube - Seu navegador de diagnósticos Kubernetes
🔧 Configurando acesso agnóstico ao cluster...
🔍 Servidor: https://127.0.0.1:6443
   📍 Tipo: Cluster Local
   🔄 Ajustando para host.docker.internal...
   🔐 Certificado CA presente - mantendo validação
✅ Kubeconfig configurado e pronto
🔍 Testando conectividade com o cluster...
✅ Cluster acessível!
   📊 Nodes: 1
   🎯 Contexto: docker-desktop
   🐳 Versão K8s: v1.28.2
```

### Exemplo 2: AWS EKS
```bash
# Usuário já tem aws configure feito
docker-compose up -d

# Saída do container:
⚓ NautiKube - Seu navegador de diagnósticos Kubernetes
🔧 Configurando acesso agnóstico ao cluster...
🔍 Servidor: https://XXXX.eks.us-east-1.amazonaws.com
   ☁️  Tipo: AWS EKS
   ✓ Usando configuração nativa (sem ajustes)
✅ Kubeconfig configurado e pronto
🔍 Testando conectividade com o cluster...
✅ Cluster acessível!
   📊 Nodes: 3
   🎯 Contexto: eks-production
   🐳 Versão K8s: v1.27.5-eks-2d98532
```

### Exemplo 3: Kind
```bash
# Usuário criou cluster Kind
kind create cluster --name meu-cluster
docker-compose up -d

# Saída do container:
⚓ NautiKube - Seu navegador de diagnósticos Kubernetes
🔧 Configurando acesso agnóstico ao cluster...
🔍 Servidor: https://127.0.0.1:6550
   📍 Tipo: Cluster Local
   🔄 Ajustando para host.docker.internal...
   🔓 Sem CA - usando insecure-skip-tls-verify
✅ Kubeconfig configurado e pronto
🔍 Testando conectividade com o cluster...
✅ Cluster acessível!
   📊 Nodes: 1
   🎯 Contexto: kind-meu-cluster
   🐳 Versão K8s: v1.27.3
```

## 🐛 Troubleshooting

Se a conexão falhar, o container mostra:

```bash
⚠️  Primeira tentativa falhou, tentando estratégias alternativas...
   🔄 Tentando com insecure-skip-tls-verify...
   ❌ Ainda sem conexão
   💡 Dicas de troubleshooting:
      - Verifique se o cluster está rodando
      - Confirme o kubeconfig montado: docker exec nautikube cat /root/.kube/config
      - Teste fora do container: kubectl cluster-info
      - Para clusters EKS: verifique ~/.aws/credentials
```

## 🔒 Segurança

### Ordem de Prioridade (do mais seguro para menos)

1. **Validação completa de certificado** (padrão)
2. **Validação com CA do kubeconfig**
3. **insecure-skip-tls-verify** (fallback, apenas para localhost)

### Clusters em Cloud
- Sempre usa autenticação nativa (aws/az/gcloud)
- Nunca usa insecure-skip-tls-verify
- Respeita políticas IAM/RBAC

## 📈 Performance

- Timeout configurável (30s padrão)
- QPS otimizado para clusters grandes
- Cache de descoberta de API habilitado
- Conexões keepalive mantidas

## 🎓 Aprendizados Técnicos

### Por que `host.docker.internal`?

Containers Docker não podem acessar `localhost` ou `127.0.0.1` do host. O Docker fornece `host.docker.internal` como um DNS especial que resolve para o IP do host.

### Por que múltiplos fallbacks?

Diferentes ambientes têm diferentes configurações:
- Dentro do cluster: usa service account
- Docker: usa kubeconfig modificado
- Local: usa kubeconfig padrão
- CI/CD: usa variável KUBECONFIG

### Por que insecure-skip-tls-verify para localhost?

Certificados TLS de clusters locais são emitidos para `127.0.0.1` e `localhost`, não para `host.docker.internal`. Como estamos apenas desenvolvendo localmente, é aceitável pular a validação.

## 🚀 Próximos Passos

Possíveis melhorias futuras:
- [ ] Suporte para múltiplos contextos simultaneamente
- [ ] Cache de configuração para startup mais rápido
- [ ] Detecção de proxy corporativo automática
- [ ] Suporte para clusters com autenticação OIDC
- [ ] Métricas de conectividade e latência

## 📚 Referências

- [Kubernetes Client Configuration](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
- [Docker Desktop Networking](https://docs.docker.com/desktop/networking/)
- [AWS EKS Authentication](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html)
- [client-go Documentation](https://github.com/kubernetes/client-go)

---

**Versão:** 2.0.3  
**Data:** 19 de Novembro de 2025  
**Autor:** NautiKube Team
