# Comandos Rápidos - v2.0.3

## 🚀 Teste Rápido

### 1. Rebuild e Start
```powershell
docker-compose down
docker-compose build --no-cache nautikube
docker-compose up -d
```

### 2. Ver Logs de Detecção
```powershell
docker logs nautikube
```

### 3. Testar Análise
```powershell
docker exec nautikube nautikube analyze
```

### 4. Testar com Explicação
```powershell
docker exec nautikube nautikube analyze --explain
```

## 🔍 Debug

### Ver Kubeconfig Original
```powershell
docker exec nautikube cat /root/.kube/config
```

### Ver Kubeconfig Modificado
```powershell
docker exec nautikube cat /root/.kube/config_mod
```

### Ver Servidor Detectado
```powershell
docker exec nautikube grep "server:" /root/.kube/config_mod
```

### Testar Conectividade Dentro do Container
```powershell
docker exec nautikube kubectl cluster-info
docker exec nautikube kubectl get nodes
```

## 📊 Verificar Status

### Status dos Containers
```powershell
docker-compose ps
```

### Logs em Tempo Real
```powershell
docker logs -f nautikube
```

### Versão do NautiKube
```powershell
docker exec nautikube nautikube version
```

## 🧹 Cleanup

### Parar Tudo
```powershell
docker-compose down
```

### Remover Volumes
```powershell
docker-compose down -v
```

### Rebuild Total (limpa cache)
```powershell
docker-compose down
docker system prune -f
docker-compose build --no-cache
docker-compose up -d
```

## 🎯 Validação Completa

### Comando Único (copia e cola)
```powershell
# Rebuild, start, aguarda e testa
docker-compose down; docker-compose build --no-cache nautikube; docker-compose up -d; Start-Sleep -Seconds 15; docker logs nautikube; docker exec nautikube nautikube analyze
```

## 🐛 Se Algo Der Errado

### Ver Todos os Logs
```powershell
docker logs nautikube 2>&1 | Out-File -FilePath logs.txt
notepad logs.txt
```

### Entrar no Container
```powershell
docker exec -it nautikube /bin/sh
```

### Dentro do Container
```bash
# Ver arquivos de config
ls -la /root/.kube/

# Testar kubectl diretamente
kubectl version
kubectl cluster-info
kubectl get nodes

# Ver variáveis de ambiente
env | grep KUBE

# Sair
exit
```

## ✅ Checklist Rápido

- [ ] `docker logs nautikube` mostra tipo de cluster detectado
- [ ] `docker logs nautikube` mostra "✅ Cluster acessível!"
- [ ] `docker exec nautikube nautikube analyze` retorna dados
- [ ] Nenhum erro de certificado ou autenticação

## 📝 Comandos Git (após validação)

```powershell
# Status
git status

# Add
git add configs/entrypoint-nautikube.sh internal/scanner/scanner.go CHANGELOG.md README.md docs/ tests/

# Commit
git commit -m "feat(v2.0.3): Implementa conexão agnóstica e transparente com clusters"

# Push
git push origin main
```

---

**Versão:** 2.0.3  
**Data:** 19 de Novembro de 2025
