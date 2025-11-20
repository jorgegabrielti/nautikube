# Guia de Teste - Conexão Agnóstica v2.0.3

## 🎯 Objetivo

Validar que a nova implementação de conexão agnóstica funciona corretamente com seu cluster.

## 🚀 Teste Rápido (5 minutos)

### 1. Verificar Cluster Ativo

```powershell
# Confirme que seu cluster está rodando
kubectl cluster-info
kubectl get nodes
```

### 2. Rebuild e Restart

```powershell
# Reconstrua a imagem com as novas mudanças
docker-compose down
docker-compose build --no-cache nautikube
docker-compose up -d
```

### 3. Observar Logs de Inicialização

```powershell
# Veja os logs do container
docker logs nautikube

# Procure por:
# ✅ Tipo detectado (Local/EKS/AKS/GKE/etc)
# ✅ Kubeconfig configurado
# ✅ Cluster acessível
# ✅ Número de nodes detectados
```

### 4. Testar Comando Analyze

```powershell
# Teste básico
docker exec nautikube nautikube analyze

# Teste com explicação
docker exec nautikube nautikube analyze --explain
```

## 📋 Checklist de Validação

### ✅ Detecção Automática
- [ ] Container detectou o tipo correto de cluster
- [ ] Mensagem clara sobre o tipo (Local/Cloud/Customizado)
- [ ] Nenhum erro durante configuração do kubeconfig

### ✅ Conectividade
- [ ] Container conectou ao cluster com sucesso
- [ ] Número correto de nodes mostrado
- [ ] Versão do Kubernetes detectada
- [ ] Contexto correto mostrado

### ✅ Funcionalidade
- [ ] Comando `analyze` funciona
- [ ] Comando `analyze --explain` funciona
- [ ] Consegue listar pods/resources
- [ ] Nenhum erro de autenticação

### ✅ Mensagens Informativas
- [ ] Logs são claros e informativos
- [ ] Emojis e formatação corretos
- [ ] Se houver falha, dicas de troubleshooting aparecem

## 🔍 Teste por Tipo de Cluster

### Docker Desktop / Minikube / Kind

```powershell
# Deve ver:
# 📍 Tipo: Cluster Local
# 🔄 Ajustando para host.docker.internal...
# ✅ Cluster acessível!
```

### AWS EKS

```powershell
# Deve ver:
# ☁️  Tipo: AWS EKS
# ✓ Usando configuração nativa (sem ajustes)
# ✅ Cluster acessível!
```

### Azure AKS

```powershell
# Deve ver:
# ☁️  Tipo: Azure AKS
# ✓ Usando configuração nativa (sem ajustes)
# ✅ Cluster acessível!
```

### Google GKE

```powershell
# Deve ver:
# ☁️  Tipo: Google GKE
# ✓ Usando configuração nativa (sem ajustes)
# ✅ Cluster acessível!
```

## 🐛 Troubleshooting

### Problema: Container não detecta o cluster

```powershell
# Verifique se o kubeconfig está montado
docker exec nautikube cat /root/.kube/config

# Se estiver vazio ou com erro, verifique o docker-compose.yml:
# volumes:
#   - ${HOME}/.kube/config:/root/.kube/config:ro
```

### Problema: Falha na conexão

```powershell
# Veja os logs completos
docker logs nautikube

# Verifique se o cluster está acessível fora do container
kubectl cluster-info

# Para clusters locais, confirme que está usando host.docker.internal
docker exec nautikube grep "server:" /root/.kube/config_mod
```

### Problema: Erro de certificado

```powershell
# Verifique se insecure-skip-tls-verify foi aplicado (clusters locais)
docker exec nautikube grep "insecure-skip-tls-verify" /root/.kube/config_mod

# Se não estiver presente e for cluster local, é um bug
```

## 🧪 Teste Automatizado (Opcional)

Se você tem múltiplos clusters configurados:

```bash
# No Linux/Mac/WSL
chmod +x tests/test-agnostic-connection.sh
./tests/test-agnostic-connection.sh
```

```powershell
# No Windows PowerShell (conversão necessária)
# O script precisa ser adaptado para PowerShell
# Ou execute via WSL/Git Bash
```

## 📊 Resultados Esperados

### ✅ Sucesso Total
```
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
🤖 Verificando Ollama...
✅ Ollama acessível em http://host.docker.internal:11434
   1 modelo(s) instalado(s)
🚀 NautiKube v2.0.3 pronto!
```

### ⚠️ Sucesso com Fallback
```
⚓ NautiKube - Seu navegador de diagnósticos Kubernetes
🔧 Configurando acesso agnóstico ao cluster...
🔍 Servidor: https://127.0.0.1:6550
   📍 Tipo: Cluster Local
   🔄 Ajustando para host.docker.internal...
   🔐 Certificado CA presente - mantendo validação
✅ Kubeconfig configurado e pronto
🔍 Testando conectividade com o cluster...
⚠️  Primeira tentativa falhou, tentando estratégias alternativas...
   🔄 Tentando com insecure-skip-tls-verify...
   ✅ Conectado com insecure-skip-tls-verify!
```

### ❌ Falha (exemplo de troubleshooting)
```
⚓ NautiKube - Seu navegador de diagnósticos Kubernetes
🔧 Configurando acesso agnóstico ao cluster...
🔍 Servidor: https://127.0.0.1:6443
   📍 Tipo: Cluster Local
   🔄 Ajustando para host.docker.internal...
✅ Kubeconfig configurado e pronto
🔍 Testando conectividade com o cluster...
⚠️  Primeira tentativa falhou, tentando estratégias alternativas...
   🔄 Tentando com insecure-skip-tls-verify...
   ❌ Ainda sem conexão
   💡 Dicas de troubleshooting:
      - Verifique se o cluster está rodando
      - Confirme o kubeconfig montado: docker exec nautikube cat /root/.kube/config
      - Teste fora do container: kubectl cluster-info
```

## 📝 Reportar Resultados

Se encontrar problemas, por favor documente:

1. **Tipo de cluster**: Docker Desktop, Kind, EKS, etc.
2. **Versão do Kubernetes**: `kubectl version --short`
3. **Logs completos**: `docker logs nautikube`
4. **Conteúdo do kubeconfig_mod**: `docker exec nautikube cat /root/.kube/config_mod`
5. **Resultado do teste fora do container**: `kubectl cluster-info`

## ✅ Confirmação de Sucesso

Considere o teste bem-sucedido se:

1. ✅ Container iniciou sem erros
2. ✅ Tipo de cluster foi detectado corretamente
3. ✅ Conectividade estabelecida (primeira tentativa ou fallback)
4. ✅ Comando `analyze` retorna dados do cluster
5. ✅ Nenhum erro de autenticação ou certificado persistente

## 🎉 Próximos Passos

Se todos os testes passaram:

1. Commit as mudanças
2. Atualize a versão se necessário
3. Crie uma tag de release
4. Atualize a documentação se houver casos específicos

---

**Versão:** 2.0.3  
**Data:** 19 de Novembro de 2025
