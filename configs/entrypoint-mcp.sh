#!/bin/sh

echo "🚀 Preparando ambiente K8sGPT MCP..."

# Ajusta o kubeconfig substituindo 127.0.0.1 por host.docker.internal
if [ -f /root/.kube/config ]; then
    sed 's/127\.0\.0\.1/host.docker.internal/g' /root/.kube/config > /root/.kube/config_mod
    export KUBECONFIG=/root/.kube/config_mod
    echo "✅ Kubeconfig configurado"
fi

# Configurar backend fake (K8sGPT exige, mas MCP não usará)
k8sgpt auth add --backend openai --model gpt-3.5-turbo --password fake-key 2>/dev/null || true
k8sgpt auth default -p openai 2>/dev/null || true

echo "✅ Container pronto! GitHub Copilot pode executar comandos k8sgpt"

# Manter container rodando
exec "$@"
