# Histórico de Mudanças

Todas as mudanças notáveis do mekhanikube serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto segue [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-09

### Adicionado
- Lançamento inicial do mekhanikube 🔧
- Configuração Docker Compose com K8sGPT e Ollama
- Ajuste automático de kubeconfig para contêineres Docker
- Auto-configuração da autenticação K8sGPT na inicialização
- Suporte para modelo gemma:7b (padrão)
- Volumes persistentes para modelos e configuração
- README abrangente com instruções de configuração e uso
- Licença MIT

### Funcionalidades
- Análise de cluster Kubernetes alimentada por IA
- Integração com LLM local (sem chamadas de API externas)
- Detecção de problemas em múltiplos tipos de recursos K8s
- Explicações e soluções automáticas via Ollama
- Suporte a filtros (Pod, Service, ConfigMap, Deployment, etc)
- Análise com escopo de namespace
- Suporte para Windows/Linux/macOS via Docker

### Componentes
- K8sGPT: Construído da fonte oficial (latest)
- Ollama: Imagem oficial (latest)
- Modelos: gemma:7b (5GB)
- Imagens base: golang:1.23-alpine, alpine:latest

[1.0.0]: https://github.com/jorgegabrielti/mekhanikube/releases/tag/v1.0.0

