#!/bin/bash
# Script de teste para validar conexão agnóstica com diferentes tipos de clusters
# Versão: 2.0.3

set -e

echo "🧪 NautiKube - Teste de Conexão Agnóstica v2.0.3"
echo "================================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Função para testar conexão com cluster
test_cluster() {
    local cluster_name=$1
    local context=$2
    
    echo -e "${BLUE}🔍 Testando: $cluster_name${NC}"
    
    # Verifica se o contexto existe
    if ! kubectl config get-contexts "$context" > /dev/null 2>&1; then
        echo -e "${YELLOW}   ⊘ Cluster não encontrado - PULADO${NC}"
        ((TESTS_SKIPPED++))
        echo ""
        return
    fi
    
    # Muda para o contexto
    kubectl config use-context "$context" > /dev/null 2>&1
    
    # Recria containers com o novo contexto
    echo "   ↻ Recriando containers..."
    docker-compose down > /dev/null 2>&1
    docker-compose up -d > /dev/null 2>&1
    
    # Aguarda inicialização
    echo "   ⏳ Aguardando inicialização (10s)..."
    sleep 10
    
    # Captura logs do entrypoint
    echo "   📋 Analisando logs de detecção..."
    LOGS=$(docker logs nautikube 2>&1)
    
    # Verifica detecção de tipo
    if echo "$LOGS" | grep -q "Tipo:"; then
        DETECTED_TYPE=$(echo "$LOGS" | grep "Tipo:" | head -1 | sed 's/.*Tipo: //')
        echo -e "   ✓ Tipo detectado: ${GREEN}$DETECTED_TYPE${NC}"
    else
        echo -e "   ${RED}✗ Falha na detecção de tipo${NC}"
        ((TESTS_FAILED++))
        echo ""
        return
    fi
    
    # Verifica se a configuração foi bem-sucedida
    if echo "$LOGS" | grep -q "✅ Kubeconfig configurado"; then
        echo -e "   ${GREEN}✓ Kubeconfig configurado com sucesso${NC}"
    else
        echo -e "   ${RED}✗ Falha na configuração do kubeconfig${NC}"
        ((TESTS_FAILED++))
        echo ""
        return
    fi
    
    # Verifica conectividade
    if echo "$LOGS" | grep -q "✅ Cluster acessível"; then
        echo -e "   ${GREEN}✓ Cluster acessível${NC}"
        
        # Extrai informações do cluster
        NODE_COUNT=$(echo "$LOGS" | grep "Nodes:" | sed 's/.*Nodes: //')
        K8S_VERSION=$(echo "$LOGS" | grep "Versão K8s:" | sed 's/.*Versão K8s: //')
        
        echo "   📊 Informações do cluster:"
        echo "      - Nodes: $NODE_COUNT"
        echo "      - Versão: $K8S_VERSION"
        
        # Testa comando analyze
        echo "   🔍 Testando comando analyze..."
        if docker exec nautikube nautikube analyze > /dev/null 2>&1; then
            echo -e "   ${GREEN}✓ Comando analyze funcional${NC}"
            ((TESTS_PASSED++))
        else
            echo -e "   ${RED}✗ Comando analyze falhou${NC}"
            ((TESTS_FAILED++))
        fi
    else
        echo -e "   ${RED}✗ Cluster não acessível${NC}"
        echo "   ℹ Logs completos:"
        echo "$LOGS" | grep -A 5 "Testando conectividade"
        ((TESTS_FAILED++))
    fi
    
    echo ""
}

# Testa clusters disponíveis
echo "🎯 Iniciando testes de compatibilidade..."
echo ""

# Obtém lista de contextos disponíveis
CONTEXTS=$(kubectl config get-contexts -o name 2>/dev/null || echo "")

if [ -z "$CONTEXTS" ]; then
    echo -e "${RED}❌ Nenhum contexto Kubernetes encontrado!${NC}"
    echo "   Configure pelo menos um cluster para testar."
    exit 1
fi

echo "📋 Contextos disponíveis:"
echo "$CONTEXTS" | while read -r ctx; do
    echo "   • $ctx"
done
echo ""

# Testes específicos por tipo de cluster
test_cluster "Docker Desktop" "docker-desktop"
test_cluster "Docker Desktop (alternate)" "docker-for-desktop"
test_cluster "Minikube" "minikube"
test_cluster "Kind (default)" "kind-kind"
test_cluster "k3d (default)" "k3d-k3s-default"
test_cluster "MicroK8s" "microk8s"

# Testa todos os contextos que começam com 'kind-'
for ctx in $CONTEXTS; do
    if [[ $ctx == kind-* ]] && [[ $ctx != "kind-kind" ]]; then
        test_cluster "Kind ($ctx)" "$ctx"
    fi
done

# Testa todos os contextos que começam com 'k3d-'
for ctx in $CONTEXTS; do
    if [[ $ctx == k3d-* ]] && [[ $ctx != "k3d-k3s-default" ]]; then
        test_cluster "k3d ($ctx)" "$ctx"
    fi
done

# Testa contextos de cloud (EKS, AKS, GKE)
for ctx in $CONTEXTS; do
    # EKS
    if [[ $ctx == *"eks"* ]]; then
        test_cluster "AWS EKS ($ctx)" "$ctx"
    fi
    # AKS
    if [[ $ctx == *"aks"* ]] || [[ $ctx == *"azure"* ]]; then
        test_cluster "Azure AKS ($ctx)" "$ctx"
    fi
    # GKE
    if [[ $ctx == *"gke"* ]] || [[ $ctx == *"google"* ]]; then
        test_cluster "Google GKE ($ctx)" "$ctx"
    fi
done

# Relatório final
echo "================================================"
echo "📊 RELATÓRIO FINAL"
echo "================================================"
echo -e "✅ Testes bem-sucedidos: ${GREEN}$TESTS_PASSED${NC}"
echo -e "❌ Testes falhados: ${RED}$TESTS_FAILED${NC}"
echo -e "⊘  Testes pulados: ${YELLOW}$TESTS_SKIPPED${NC}"
echo ""

TOTAL=$((TESTS_PASSED + TESTS_FAILED))
if [ $TOTAL -gt 0 ]; then
    SUCCESS_RATE=$((TESTS_PASSED * 100 / TOTAL))
    echo "Taxa de sucesso: $SUCCESS_RATE%"
fi

echo ""
if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Todos os testes passaram!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Alguns testes falharam. Revise os logs acima.${NC}"
    exit 1
fi
