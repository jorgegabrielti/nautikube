# ⚠️ Ambiente Corporativo Detectado!

Se você está tentando usar o NautiKube em um ambiente com **proxy corporativo** ou **cluster EKS**, você PRECISA configurar o arquivo `.env`.

## 🔴 Sintomas de que você PRECISA do .env:

### Proxy Corporativo:
- ❌ Erro ao fazer `ollama pull`: `certificate signed by unknown authority`
- ❌ Erro de TLS/SSL ao baixar modelos
- ❌ Timeout ao conectar com registry.ollama.ai

### Cluster EKS:
- ❌ Erro: `executable aws not found`
- ❌ Erro: `getting credentials: exec: executable aws failed`
- ❌ Não consegue listar nodes do cluster

## ✅ Solução Rápida:

```bash
# 1. Copie o exemplo
cp .env.example .env

# 2. Para PROXY CORPORATIVO - exporte os certificados:
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/corporate-certs.pem
security find-certificate -a -p /Library/Keychains/System.keychain >> ~/corporate-certs.pem

# 3. Edite o .env e descomente:
nano .env
# Descomente e configure:
# CORPORATE_CERT_PATH=~/corporate-certs.pem
# AWS_CREDENTIALS_PATH=~/.aws (para EKS)

# 4. Reinicie os containers
docker-compose down
docker-compose up -d
```

## 📋 Quando NÃO precisa do .env:

✅ Kubernetes local (minikube, kind, k3s, Docker Desktop)  
✅ Sem proxy corporativo  
✅ Internet direta sem interceptação SSL  

Nestes casos, simplesmente:
```bash
docker-compose up -d
```

---

**Documentação completa**: [docs/SETUP-ENVIRONMENTS.md](../docs/SETUP-ENVIRONMENTS.md)
