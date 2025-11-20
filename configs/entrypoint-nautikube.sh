#!/bin/sh
set -e

echo "⚓ NautiKube - Seu navegador de diagnósticos Kubernetes"
echo ""

# Função para ajustar kubeconfig de forma agnóstica
configure_kubeconfig() {
    if [ ! -f "/root/.kube/config" ]; then
        echo "⚠️  Kubeconfig não encontrado em /root/.kube/config"
        echo "   O container pode não conseguir acessar o cluster"
        return 1
    fi
    
    echo "🔧 Configurando acesso agnóstico ao cluster..."
    
    # Cria cópia do kubeconfig para modificações
    cp /root/.kube/config /root/.kube/config_mod
    
    # Extrai informações do kubeconfig
    SERVER_URL=$(grep -m 1 "server:" /root/.kube/config | awk '{print $2}')
    
    if [ -z "$SERVER_URL" ]; then
        echo "⚠️  Servidor não detectado no kubeconfig"
        return 1
    fi
    
    echo "🔍 Servidor: $SERVER_URL"
    
    # Detecção inteligente e ajustes automáticos
    case "$SERVER_URL" in
        https://127.0.0.1:* | https://localhost:*)
            # Clusters locais: Kind, Minikube, Docker Desktop, k3d
            echo "   📍 Tipo: Cluster Local"
            echo "   🔄 Ajustando para host.docker.internal..."
            
            # Substitui localhost/127.0.0.1 por host.docker.internal
            sed -i 's|https://127.0.0.1|https://host.docker.internal|g; \
                    s|https://localhost|https://host.docker.internal|g' \
                /root/.kube/config_mod
            
            # Para clusters locais, o certificado não contém host.docker.internal
            # Sempre remove CA e usa insecure-skip-tls-verify (desenvolvimento local)
            echo "   🔓 Usando insecure-skip-tls-verify (cluster local)"
            
            # Remove certificate-authority-data
            sed -i '/certificate-authority-data:/d' /root/.kube/config_mod
            
            # Adiciona insecure-skip-tls-verify em cada cluster
            sed -i '/server: https:\/\/host.docker.internal/a\    insecure-skip-tls-verify: true' \
                /root/.kube/config_mod
            ;;
            
        https://*.eks.amazonaws.com*)
            # AWS EKS
            echo "   ☁️  Tipo: AWS EKS"
            echo "   ✓ Usando configuração nativa (sem ajustes)"
            # EKS usa autenticação via AWS CLI - mantém configuração original
            ;;
            
        https://*.azmk8s.io*)
            # Azure AKS
            echo "   ☁️  Tipo: Azure AKS"
            echo "   ✓ Usando configuração nativa (sem ajustes)"
            # AKS usa autenticação via Azure CLI - mantém configuração original
            ;;
            
        https://*.container.googleapis.com* | https://*.pkg.dev*)
            # Google GKE
            echo "   ☁️  Tipo: Google GKE"
            echo "   ✓ Usando configuração nativa (sem ajustes)"
            # GKE usa autenticação via gcloud - mantém configuração original
            ;;
            
        https://*:6443 | https://*:443)
            # Clusters customizados/bare-metal (porta comum do Kubernetes)
            echo "   🔧 Tipo: Cluster Customizado"
            echo "   ✓ Usando configuração direta"
            # Mantém como está - assume que já está configurado corretamente
            ;;
            
        *)
            # Qualquer outro tipo - abordagem genérica
            echo "   🌐 Tipo: Cluster Genérico"
            echo "   ✓ Usando configuração padrão"
            # Tenta usar como está, confiando na configuração do usuário
            ;;
    esac
    
    export KUBECONFIG=/root/.kube/config_mod
    echo "✅ Kubeconfig configurado e pronto"
    return 0
}

# Configura o kubeconfig
configure_kubeconfig

# Verificação inteligente de conectividade
echo ""
echo "🔍 Testando conectividade com o cluster..."

# Primeira tentativa: conexão direta
if kubectl cluster-info > /dev/null 2>&1; then
    echo "✅ Cluster acessível!"
    
    # Informações do cluster
    NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | wc -l || echo "0")
    CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null || echo "N/A")
    K8S_VERSION=$(kubectl version --short 2>/dev/null | grep "Server Version" | awk '{print $3}' || echo "N/A")
    
    echo "   📊 Nodes: $NODE_COUNT"
    echo "   🎯 Contexto: $CURRENT_CONTEXT"
    echo "   🐳 Versão K8s: $K8S_VERSION"
else
    echo "⚠️  Primeira tentativa falhou, tentando estratégias alternativas..."
    
    # Estratégia 2: Limpa duplicatas e garante insecure-skip-tls-verify
    echo "   🔄 Limpando configuração e forçando insecure-skip-tls-verify..."
    
    # Remove todas as linhas duplicadas de server e insecure
    awk '!seen[$0]++' /root/.kube/config_mod > /root/.kube/config_mod.tmp
    mv /root/.kube/config_mod.tmp /root/.kube/config_mod
    
    # Remove CA completamente
    sed -i '/certificate-authority-data:/d' /root/.kube/config_mod
    
    # Garante que insecure está presente se ainda não estiver
    if ! grep -q "insecure-skip-tls-verify: true" /root/.kube/config_mod; then
        sed -i '/server: https:\/\//a\    insecure-skip-tls-verify: true' /root/.kube/config_mod
    fi
    
    if kubectl cluster-info > /dev/null 2>&1; then
        echo "   ✅ Conectado após ajustes!"
        
        # Mostra informações do cluster
        NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | wc -l || echo "0")
        CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null || echo "N/A")
        K8S_VERSION=$(kubectl version --short 2>/dev/null | grep "Server Version" | awk '{print $3}' || echo "N/A")
        
        echo "   📊 Nodes: $NODE_COUNT"
        echo "   🎯 Contexto: $CURRENT_CONTEXT"
        echo "   🐳 Versão K8s: $K8S_VERSION"
    else
        echo "   ❌ Ainda sem conexão"
        echo "   💡 Dicas de troubleshooting:"
        echo "      - Verifique se o cluster está rodando: kubectl cluster-info"
        echo "      - Confirme o kubeconfig montado: docker exec nautikube cat /root/.kube/config"
        echo "      - Para clusters EKS: verifique ~/.aws/credentials"
        echo "      - Servidor detectado: $(grep -m 1 'server:' /root/.kube/config_mod | awk '{print $2}')"
    fi
fi

# Verifica conectividade com Ollama
echo ""
echo "🤖 Verificando Ollama..."
if curl -s http://host.docker.internal:11434/api/tags > /dev/null 2>&1; then
    echo "✅ Ollama acessível em http://host.docker.internal:11434"
    
    # Lista modelos instalados
    MODEL_COUNT=$(curl -s http://host.docker.internal:11434/api/tags 2>/dev/null | grep -o '"name"' | wc -l || echo "0")
    if [ "$MODEL_COUNT" -gt 0 ]; then
        echo "   $MODEL_COUNT modelo(s) instalado(s)"
    fi
else
    echo "⚠️  Ollama não acessível"
    echo "   Use 'analyze' sem --explain para análise básica"
fi

echo ""
echo "🚀 NautiKube v2.0.3 pronto!"
echo "   Uso: docker exec nautikube nautikube analyze --explain"
echo ""

# Mantém container rodando
tail -f /dev/null
