# NautiKube Helper Scripts
# Facilita o uso do NautiKube com e sem GPU

# ====================
# Iniciar com CPU (padrão)
# ====================
function Start-NautiKube {
    Write-Host "🚀 Iniciando NautiKube (CPU)..." -ForegroundColor Cyan
    docker-compose up -d
    Write-Host "✅ NautiKube iniciado! Aguarde ~30s para o healthcheck." -ForegroundColor Green
}

# ====================
# Iniciar com GPU NVIDIA
# ====================
function Start-NautiKube-GPU {
    Write-Host "🎮 Verificando GPU NVIDIA..." -ForegroundColor Cyan
    
    # Verifica se nvidia-smi está disponível no WSL
    $gpuCheck = wsl nvidia-smi 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ GPU NVIDIA não detectada no WSL2!" -ForegroundColor Red
        Write-Host "   Execute: wsl nvidia-smi" -ForegroundColor Yellow
        Write-Host "   Veja: docs/GPU-SETUP.md" -ForegroundColor Yellow
        return
    }
    
    Write-Host "✅ GPU detectada!" -ForegroundColor Green
    Write-Host "🚀 Iniciando NautiKube com GPU..." -ForegroundColor Cyan
    docker-compose -f docker-compose.yml -f docker-compose.gpu.yml up -d
    Write-Host "✅ NautiKube com GPU iniciado!" -ForegroundColor Green
}

# ====================
# Parar containers
# ====================
function Stop-NautiKube {
    Write-Host "🛑 Parando NautiKube..." -ForegroundColor Yellow
    docker-compose down
    Write-Host "✅ NautiKube parado!" -ForegroundColor Green
}

# ====================
# Status dos containers
# ====================
function Get-NautiKube-Status {
    Write-Host "📊 Status do NautiKube:" -ForegroundColor Cyan
    docker-compose ps
}

# ====================
# Ver logs
# ====================
function Get-NautiKube-Logs {
    param(
        [string]$Service = "nautikube"
    )
    docker-compose logs -f $Service
}

# ====================
# Verificar uso de GPU (durante análise)
# ====================
function Watch-NautiKube-GPU {
    Write-Host "🎮 Monitorando GPU (Ctrl+C para sair)..." -ForegroundColor Cyan
    while ($true) {
        Clear-Host
        docker exec nautikube-ollama nvidia-smi
        Start-Sleep -Seconds 2
    }
}

# ====================
# Análise rápida
# ====================
function Invoke-NautiKube-Analyze {
    param(
        [switch]$Explain,
        [string]$Namespace = "",
        [string]$Filter = ""
    )
    
    $cmd = "docker exec nautikube nautikube analyze"
    
    if ($Explain) { $cmd += " --explain" }
    if ($Namespace) { $cmd += " -n $Namespace" }
    if ($Filter) { $cmd += " --filter $Filter" }
    
    Write-Host "🔍 Executando: $cmd" -ForegroundColor Cyan
    Invoke-Expression $cmd
}

# ====================
# Mensagem de ajuda
# ====================
Write-Host @"

🚢 NautiKube Helper Scripts carregados!

Comandos disponíveis:
  Start-NautiKube           - Inicia com CPU (padrão)
  Start-NautiKube-GPU       - Inicia com GPU NVIDIA
  Stop-NautiKube            - Para todos os containers
  Get-NautiKube-Status      - Mostra status dos containers
  Get-NautiKube-Logs        - Ver logs (use -Service para especificar)
  Watch-NautiKube-GPU       - Monitora uso da GPU em tempo real
  Invoke-NautiKube-Analyze  - Executa análise (use -Explain, -Namespace, -Filter)

Exemplos:
  Start-NautiKube-GPU
  Invoke-NautiKube-Analyze -Explain
  Invoke-NautiKube-Analyze -Namespace kube-system -Explain
  Watch-NautiKube-GPU

📖 Documentação: docs/GPU-SETUP.md

"@ -ForegroundColor Green
