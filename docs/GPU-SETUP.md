# 🚀 Configuração de GPU NVIDIA para NautiKube

Este guia mostra como configurar sua GPU NVIDIA para acelerar as análises com IA no NautiKube.

## 📋 Pré-requisitos

- ✅ Placa de vídeo NVIDIA (GeForce, RTX, Quadro, Tesla)
- ✅ Windows 10/11 com WSL2 instalado
- ✅ Docker Desktop for Windows
- ✅ Drivers NVIDIA atualizados (versão 470.76 ou superior)

## 🔧 Passo a Passo

### 1. Verificar se a GPU está disponível no WSL2

Abra o PowerShell e execute:

```powershell
wsl nvidia-smi
```

**Saída esperada:**
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 535.xx.xx    Driver Version: 535.xx.xx    CUDA Version: 12.x   |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ... Off  | 00000000:01:00.0 Off |                  N/A |
| N/A   45C    P8     5W /  N/A |      0MiB /  4096MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

❌ **Se não funcionar**, você precisa:
1. Atualizar drivers NVIDIA: https://www.nvidia.com/Download/index.aspx
2. Verificar se WSL2 está atualizado: `wsl --update`
3. Reiniciar o computador

### 2. Verificar Docker Desktop

No Docker Desktop:
1. Abra **Settings** (ícone de engrenagem)
2. Vá em **Resources** → **WSL Integration**
3. Certifique-se que **Enable integration with my default WSL distro** está marcado
4. Clique em **Apply & Restart**

### 3. Testar GPU no Docker

```powershell
docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
```

**Se funcionar**, você verá a saída do `nvidia-smi` dentro do container.

❌ **Se der erro "could not select device driver"**:
- Docker Desktop pode não ter suporte GPU habilitado
- Verifique se está usando Docker Desktop 4.20 ou superior

### 4. Reiniciar NautiKube com GPU

```powershell
# Parar containers
docker-compose down

# Subir com GPU (usa docker-compose.gpu.yml como override)
docker-compose -f docker-compose.yml -f docker-compose.gpu.yml up -d

# Verificar se Ollama está usando GPU
docker exec nautikube-ollama nvidia-smi
```

> 💡 **Importante**: Usamos dois arquivos docker-compose:
> - `docker-compose.yml` - Configuração base (CPU, funciona em todos os ambientes)
> - `docker-compose.gpu.yml` - Override opcional para habilitar GPU
> 
> Isso garante que o NautiKube funciona por padrão em qualquer ambiente!

### 5. Verificar se o modelo está usando GPU

```powershell
# Durante uma análise, em outro terminal:
docker exec nautikube-ollama nvidia-smi
```

Você deve ver o processo `ollama` consumindo memória GPU e com utilização > 0%.

## 🎯 Performance Esperada

| Aspecto | CPU (Intel i7) | GPU (RTX 3050) | Melhoria |
|---------|----------------|----------------|----------|
| **Primeira análise** | ~30-60s | ~5-10s | ⚡ **6x mais rápido** |
| **Análises seguintes** | ~15-30s | ~2-5s | ⚡ **5-10x mais rápido** |
| **Timeouts** | Frequentes | Raros | ✅ **95% menos** |
| **Memória GPU** | 0 GB | ~2-3 GB | 💾 Uso moderado |

## 🔍 Troubleshooting

### Erro: "could not select device driver"

**Causa**: Docker Desktop não tem suporte GPU ou drivers incompatíveis.

**Solução**:
1. Atualizar Docker Desktop para versão 4.20+
2. Atualizar drivers NVIDIA
3. Reiniciar computador e Docker Desktop

### Erro: "CUDA error: out of memory"

**Causa**: Modelo muito grande para a GPU (RTX 3050 tem 4GB VRAM).

**Solução**: Usar modelo menor
```powershell
docker exec nautikube-ollama ollama pull llama3.1:8b  # Já é o menor recomendado
# ou
docker exec nautikube-ollama ollama pull tinyllama    # 1.1GB, mais rápido
```

### GPU não aparece no nvidia-smi dentro do container

**Causa**: Configuração do docker-compose não está correta.

**Solução**: Verificar se a seção `deploy` está presente no `docker-compose.yml`:
```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: [gpu]
```

### Performance não melhorou

**Verificações**:
1. GPU está sendo usada? `docker exec nautikube-ollama nvidia-smi` durante análise
2. Modelo foi baixado novamente após GPU? `docker exec nautikube-ollama ollama pull llama3.1:8b`
3. Containers foram reiniciados? `docker-compose restart`

## 📊 Monitoramento

Para monitorar uso da GPU em tempo real:

```powershell
# Windows PowerShell (loop)
while ($true) { 
    Clear-Host; 
    docker exec nautikube-ollama nvidia-smi; 
    Start-Sleep -Seconds 2 
}
```

## 🔄 Voltar para CPU

Se quiser desabilitar GPU, simplesmente use o docker-compose normal:

```powershell
# Parar containers
docker-compose down

# Subir sem GPU (usa apenas docker-compose.yml)
docker-compose up -d
```

Ou crie um alias no PowerShell para facilitar:

```powershell
# Adicione ao seu perfil do PowerShell (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
function Start-NautiKube-GPU {
    docker-compose -f docker-compose.yml -f docker-compose.gpu.yml up -d
}

function Start-NautiKube {
    docker-compose up -d
}

# Uso:
Start-NautiKube-GPU  # Com GPU
Start-NautiKube      # Apenas CPU
```

## 📚 Referências

- [Docker GPU Support](https://docs.docker.com/compose/gpu-support/)
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)
- [Ollama GPU Support](https://github.com/ollama/ollama/blob/main/docs/gpu.md)
- [WSL2 GPU Guide](https://docs.microsoft.com/en-us/windows/wsl/tutorials/gpu-compute)
