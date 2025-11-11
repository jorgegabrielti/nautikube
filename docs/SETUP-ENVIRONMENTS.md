# Configuração para Diferentes Ambientes

Este guia explica como configurar o NautiKube para diferentes ambientes: VM local com Kubernetes e ambientes corporativos com EKS/Proxy.

## 🖥️ Ambiente 1: VM Local com Kubernetes

**Cenário:** Kubernetes rodando em VM local (minikube, kind, k3s, etc.)

### Requisitos
- Docker / Colima instalado
- Cluster Kubernetes local rodando
- `~/.kube/config` configurado

### Setup

1. Clone o repositório:
```bash
git clone https://github.com/jorgegabrielti/nautikube.git
cd nautikube
```

2. **Não precisa criar `.env`** - O projeto funciona com as configurações padrão

3. Suba os containers:
```bash
docker-compose up -d
```

4. Baixe o modelo Ollama:
```bash
docker exec nautikube-ollama ollama pull llama3.1:8b
```

5. Teste a análise:
```bash
docker exec nautikube nautikube analyze --explain
```

### Notas
- AWS CLI está instalado no container mas não é necessário
- Proxy corporativo não é usado
- Certificados SSL padrão do sistema são suficientes

---

## 🏢 Ambiente 2: EKS + Proxy Corporativo

**Cenário:** Cluster EKS na AWS com proxy corporativo interceptando HTTPS

### Requisitos
- Docker / Colima instalado (recomendado: 4 CPUs, 8GB RAM)
- AWS CLI configurado localmente (`~/.aws/`)
- Acesso ao cluster EKS via `kubectl`
- Certificados corporativos (se atrás de proxy)

### Setup

1. Clone o repositório:
```bash
git clone https://github.com/jorgegabrielti/nautikube.git
cd nautikube
```

2. **Exporte os certificados corporativos** (se necessário):
```bash
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/corporate-certs.pem
security find-certificate -a -p /Library/Keychains/System.keychain >> ~/corporate-certs.pem
```

3. **Crie o arquivo `.env`** baseado no exemplo:
```bash
cp .env.example .env
```

4. **Edite o `.env`** e configure:
```bash
# Modelo menor para economizar memória
OLLAMA_MODEL=qwen2.5:3b

# Proxy corporativo (se necessário)
# HTTP_PROXY=http://proxy.company.com:8080
# HTTPS_PROXY=http://proxy.company.com:8080

# Caminho do certificado corporativo
CORPORATE_CERT_PATH=~/corporate-certs.pem

# AWS credentials path (geralmente não precisa mudar)
# AWS_CREDENTIALS_PATH=~/.aws
```

5. **Aumente a memória do Colima** (se usando Colima):
```bash
colima stop
colima start --cpu 4 --memory 8
```

6. Suba os containers:
```bash
docker-compose up -d
```

7. Baixe o modelo Ollama:
```bash
docker exec nautikube-ollama ollama pull qwen2.5:3b
```

8. Teste a conexão com o cluster EKS:
```bash
docker exec nautikube kubectl get nodes
```

9. Teste a análise com IA:
```bash
docker exec nautikube nautikube analyze --namespace default --explain
```

### Notas
- O AWS CLI no container usa as credenciais de `~/.aws/`
- Certificados corporativos são montados para o Ollama funcionar através do proxy
- Use modelos menores (3b-7b) para melhor performance

---

## 🔧 Configurações Avançadas

### Variáveis de Ambiente Importantes

| Variável | Padrão | Descrição | Necessário para |
|----------|--------|-----------|-----------------|
| `OLLAMA_MODEL` | `llama3.1:8b` | Modelo de IA | Ambos |
| `CORPORATE_CERT_PATH` | `~/corporate-certs.pem` | Certificado SSL | Proxy apenas |
| `HTTP_PROXY` | - | Proxy HTTP | Proxy apenas |
| `HTTPS_PROXY` | - | Proxy HTTPS | Proxy apenas |
| `AWS_PROFILE` | `default` | Perfil AWS | EKS apenas |

### Docker Compose - Como Funciona

O `docker-compose.yml` é compatível com ambos ambientes:

**Para VM Local:**
- Não monta `~/.aws` → Container funciona normalmente sem AWS
- Não monta certificados corporativos → Usa certificados do sistema
- Variáveis proxy ficam vazias → Sem proxy

**Para EKS/Proxy:**
- Monta `~/.aws` → AWS CLI pode autenticar no EKS
- Monta certificados → Ollama funciona através do proxy
- Variáveis proxy configuradas → Conexões passam pelo proxy

### Troubleshooting

#### VM Local - Erro "connection refused"
```bash
# Verifique se o cluster está rodando
kubectl cluster-info

# Verifique o kubeconfig
kubectl config view
```

#### EKS - Erro "executable aws not found"
O container precisa do AWS CLI. Reconstrua a imagem:
```bash
docker-compose build nautikube
docker-compose up -d
```

#### Proxy - Erro "certificate signed by unknown authority"
Certifique-se que os certificados foram exportados corretamente:
```bash
ls -lh ~/corporate-certs.pem
# Deve mostrar um arquivo com ~200KB+
```

#### Ollama - Erro "model requires more system memory"
Use um modelo menor ou aumente a RAM:
```bash
# Edite .env
OLLAMA_MODEL=qwen2.5:3b

# Baixe o modelo menor
docker exec nautikube-ollama ollama pull qwen2.5:3b
```

---

## 📝 Resumo Rápido

### VM Local
```bash
git clone https://github.com/jorgegabrielti/nautikube.git
cd nautikube
docker-compose up -d
docker exec nautikube-ollama ollama pull llama3.1:8b
docker exec nautikube nautikube analyze --explain
```

### EKS + Proxy
```bash
git clone https://github.com/jorgegabrielti/nautikube.git
cd nautikube
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/corporate-certs.pem
cp .env.example .env
# Edite .env conforme necessário
colima start --cpu 4 --memory 8
docker-compose up -d
docker exec nautikube-ollama ollama pull qwen2.5:3b
docker exec nautikube nautikube analyze --explain
```
