#!/bin/bash
set -e

echo "🚀 NautiKube - Inicializando..."
echo ""

# Detectar ambiente automaticamente
OVERRIDE_FILE="docker-compose.override.yml"
NEEDS_OVERRIDE=false

# Verificar se tem AWS CLI instalado e configurado (sinal de ambiente EKS)
if [ -d "$HOME/.aws" ] && [ -n "$(which aws 2>/dev/null)" ]; then
    echo "✅ Detectado: Ambiente EKS (AWS CLI encontrado)"
    NEEDS_OVERRIDE=true
else
    echo "✅ Detectado: Ambiente Kubernetes local"
fi

# Verificar se tem certificados corporativos
CERT_PATH="$HOME/corporate-certs.pem"
if [ -f "$CERT_PATH" ]; then
    echo "✅ Detectado: Certificados corporativos em $CERT_PATH"
    NEEDS_OVERRIDE=true
fi

# Criar docker-compose.override.yml automaticamente se necessário
if [ "$NEEDS_OVERRIDE" = true ]; then
    echo ""
    echo "📝 Criando configurações adicionais para EKS/Proxy..."
    
    cat > "$OVERRIDE_FILE" <<EOF
# Auto-generated override for EKS/Corporate environment
version: '3.8'

services:
EOF

    # Adicionar certificados se existirem
    if [ -f "$CERT_PATH" ]; then
        cat >> "$OVERRIDE_FILE" <<EOF
  ollama:
    volumes:
      - $CERT_PATH:/etc/ssl/certs/corporate-certs.pem:ro
    environment:
      - SSL_CERT_FILE=/etc/ssl/certs/corporate-certs.pem

EOF
    fi

    # Adicionar AWS se existir
    if [ -d "$HOME/.aws" ]; then
        cat >> "$OVERRIDE_FILE" <<EOF
  nautikube:
    volumes:
      - \${HOME}/.aws:/root/.aws:rw
    environment:
      - AWS_PROFILE=\${AWS_PROFILE:-default}
EOF
    fi
    
    echo "✅ Configurações criadas"
else
    # Remover override se existir e não for necessário
    if [ -f "$OVERRIDE_FILE" ]; then
        rm "$OVERRIDE_FILE"
        echo "🗑️  Removido override desnecessário"
    fi
fi

echo ""
echo "🐳 Iniciando containers..."
docker-compose up -d

echo ""
echo "⏳ Aguardando containers ficarem prontos..."
sleep 5

# Verificar status
if docker ps | grep -q "nautikube-ollama.*healthy"; then
    echo "✅ Ollama está rodando"
else
    echo "⚠️  Ollama ainda está inicializando..."
fi

if docker ps | grep -q "nautikube.*Up"; then
    echo "✅ NautiKube está rodando"
else
    echo "⚠️  NautiKube ainda está inicializando..."
fi

echo ""
echo "📋 Próximos passos:"
echo ""
echo "1️⃣  Baixar modelo de IA (primeira vez):"
echo "   docker exec nautikube-ollama ollama pull llama3.1:8b"
echo ""
echo "2️⃣  Testar análise do cluster:"
echo "   docker exec nautikube nautikube analyze --explain"
echo ""
echo "🎉 Para mais informações: docker logs nautikube"
