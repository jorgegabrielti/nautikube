# Perguntas Frequentes (FAQ)

## Questões Gerais

### O que é o Mekhanikube?

Mekhanikube é uma solução containerizada que combina K8sGPT e Ollama para fornecer análise alimentada por IA de clusters Kubernetes. Ele identifica problemas, explica suas causas e sugere soluções usando modelos LLM locais.

### Por que "Mekhanikube"?

**Mekhani** (Grego: μηχανικός) = mecânico + **kube** (Kubernetes) = Seu mecânico Kubernetes!

### É gratuito?

Sim! Mekhanikube é código aberto sob a Licença MIT. Todos os componentes (K8sGPT, Ollama) também são gratuitos e de código aberto.

### Ele envia meus dados para algum lugar?

Não! Tudo roda localmente na sua máquina. Os dados do seu cluster nunca saem da sua infraestrutura. Sem telemetria, sem chamadas de API externas.

---

## Instalação & Configuração

### Quais são os requisitos do sistema?

**Mínimo**:
- Docker & Docker Compose
- 2 núcleos de CPU
- 4GB RAM
- 10GB de espaço em disco
- Cluster Kubernetes ativo

**Recomendado**:
- 4+ núcleos de CPU
- 8GB+ RAM
- 20GB+ de espaço em disco

### Quais sistemas operacionais são suportados?

- ✅ Windows 10/11 (com Docker Desktop)
- ✅ macOS (Intel & Apple Silicon)
- ✅ Linux (qualquer distribuição com Docker)

### Posso usar com qualquer cluster Kubernetes?

Sim! Mekhanikube funciona com:
- Clusters locais (Docker Desktop, Minikube, Kind)
- Clusters na nuvem (EKS, GKE, AKS)
- Clusters on-premise
- Qualquer cluster acessível via kubeconfig

### Quanto tempo leva a configuração?

- Primeira vez: ~15-20 minutos (incluindo download do modelo)
- Inicializações subsequentes: ~30 segundos
- Mudanças de modelo: ~5-10 minutos por modelo

---

## Questões de Uso

### Qual modelo de IA devo usar?

| Modelo | Melhor Para | Velocidade | Qualidade | Português | Tamanho |
|--------|-------------|------------|-----------|-----------|---------|
| **llama3.1:8b** ⭐ | **Recomendado (PT-BR)** | Boa | Excelente | ⭐⭐⭐⭐⭐ | 4.7GB |
| **gemma2:9b** | Melhor qualidade | Média | Excelente | ⭐⭐⭐⭐⭐ | 5.4GB |
| **qwen2.5:7b** | Velocidade | Rápida | Muito Boa | ⭐⭐⭐⭐ | 4.7GB |
| **mistral** | Uso geral | Média | Boa | ⭐⭐⭐ | 4.1GB |
| **tinyllama** | Varreduras rápidas | Muito Rápida | Básica | ⭐⭐ | 1.1GB |

Comece com `llama3.1:8b` - oferece excelente suporte ao português brasileiro.

### Posso usar múltiplos modelos?

Sim! Instale múltiplos modelos e alterne entre eles:

```bash
# Instalar modelos adicionais
docker exec mekhanikube-ollama ollama pull mistral
docker exec mekhanikube-ollama ollama pull tinyllama

# Trocar modelo ativo
docker exec mekhanikube-ollama ollama run mistral
```

### Com que frequência devo executar a análise?

**Cronograma recomendado**:
- **Após deployments**: Verificar problemas imediatamente
- **Diariamente**: Verificações rotineiras de saúde
- **Antes de releases**: Validar estado do cluster
- **Quando alertas disparam**: Investigar causa raiz

### Posso analisar apenas recursos específicos?

Sim! Use filtros:

```bash
# Analisar apenas Pods
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Pod --explain

# Analisar apenas Services
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Service --explain

# Listar todos os filtros
docker exec mekhanikube-k8sgpt k8sgpt filters list
```

Ou namespaces específicos:

```bash
docker exec mekhanikube-k8sgpt k8sgpt analyze --namespace production --explain
```

### Que tipos de problemas ele pode detectar?

K8sGPT analisa:
- **Pods**: CrashLoopBackOff, ImagePullBackOff, OOMKilled
- **Services**: Problemas de endpoint, incompatibilidades de seletor
- **Deployments**: Problemas de réplica, problemas de atualização
- **PVCs**: Falhas de vinculação, problemas de armazenamento
- **Ingress**: Erros de configuração
- **StatefulSets**: Problemas de ordenação
- **HPA**: Problemas de escalonamento
- E mais!

---

## Questões Técnicas

### Como funciona?

1. K8sGPT escaneia seu cluster Kubernetes via API Kubernetes
2. Analisadores integrados identificam problemas (ex: pod não iniciando)
3. K8sGPT envia o contexto do problema para o Ollama
4. O LLM do Ollama gera uma explicação legível para humanos
5. Resultados são exibidos com descrição do problema, explicação da IA e correções sugeridas

### Ele modifica meu cluster?

**Não!** Mekhanikube é somente leitura. Ele:
- ✅ Lê o estado do cluster
- ✅ Analisa configurações
- ✅ Gera relatórios
- ❌ Nunca faz mudanças
- ❌ Nunca deleta recursos
- ❌ Nunca aplica configurações

### Quais permissões ele precisa?

K8sGPT requer acesso **somente leitura** aos recursos do cluster. As mesmas permissões dos comandos `kubectl get`.

### Posso executar em CI/CD?

Sim! Exemplo:

```yaml
# GitLab CI
k8s-analysis:
  script:
    - docker-compose up -d
    - docker exec mekhanikube-k8sgpt k8sgpt analyze --explain > report.txt
  artifacts:
    paths:
      - report.txt
```

### Posso exportar resultados?

Sim, use as opções de saída do K8sGPT:

```bash
# Formato JSON
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain --output json

# Salvar em arquivo
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain > analysis.txt
```

---

## Solução de Problemas

### Por que está lento?

**Possíveis causas**:
1. **Modelo grande**: Tente `tinyllama` para respostas mais rápidas
2. **Muitos recursos**: Use filtros ou escopo de namespace
3. **RAM limitada**: Aloque mais memória para o Docker
4. **Gargalo de CPU**: Feche outras aplicações

**Otimização**:
```bash
# Usar modelo menor
docker exec mekhanikube-ollama ollama pull tinyllama

# Limitar escopo
docker exec mekhanikube-k8sgpt k8sgpt analyze --namespace default --explain
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Pod --explain
```

### Diz "nenhum problema encontrado" mas sei que há problemas

1. **Verificar namespace**: Padrão é todos os namespaces
   ```bash
   docker exec mekhanikube-k8sgpt k8sgpt analyze --namespace seu-namespace --explain
   ```

2. **Tentar filtros diferentes**: Alguns problemas precisam de analisadores específicos
   ```bash
   docker exec mekhanikube-k8sgpt k8sgpt filters list
   docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Pod --explain
   ```

3. **Verificar acesso ao cluster**:
   ```bash
   docker exec mekhanikube-k8sgpt kubectl get pods --all-namespaces
   ```

### Ollama continua baixando modelos

Modelos são armazenados em volumes Docker. Se você executar `docker-compose down -v`, modelos são deletados.

**Preservar modelos**:
```bash
# Parar sem remover volumes
docker-compose down

# Ou apenas reiniciar
docker-compose restart
```

### Posso usar uma instância Ollama externa?

Sim! Modifique o `docker-compose.yml`:

```yaml
k8sgpt:
  environment:
    - OLLAMA_BASEURL=http://seu-servidor-ollama:11434
```

Então remova a definição do serviço Ollama.

---

## Uso Avançado

### Posso personalizar os analisadores do K8sGPT?

K8sGPT usa analisadores integrados. Para habilitar/desabilitar:

```bash
# Listar filtros disponíveis
docker exec mekhanikube-k8sgpt k8sgpt filters list

# Usar filtros específicos
docker exec mekhanikube-k8sgpt k8sgpt analyze --filter=Pod,Service --explain
```

### Posso usar um backend LLM diferente?

Sim! K8sGPT suporta:
- Ollama (local) - padrão
- OpenAI (nuvem)
- Azure OpenAI (nuvem)
- LocalAI (alternativa local)

Exemplo para OpenAI:
```bash
docker exec mekhanikube-k8sgpt k8sgpt auth add \
  --backend openai \
  --model gpt-4 \
  --password SUA_API_KEY
```

### Como faço backup da minha configuração?

```bash
# Backup dos modelos Ollama
docker run --rm \
  -v mekhanikube-ollama-data:/data \
  -v ${PWD}:/backup \
  alpine tar czf /backup/ollama-backup.tar.gz /data

# Backup da config K8sGPT
docker run --rm \
  -v mekhanikube-k8sgpt-config:/data \
  -v ${PWD}:/backup \
  alpine tar czf /backup/k8sgpt-backup.tar.gz /data
```

### Posso executar múltiplas instâncias?

Sim, mas altere os nomes dos contêineres para evitar conflitos:

```bash
# No arquivo .env
CONTAINER_NAME_OLLAMA=mekhanikube-ollama-2
CONTAINER_NAME_K8SGPT=mekhanikube-k8sgpt-2
OLLAMA_PORT=11435
```

### Como atualizo para a versão mais recente?

```bash
# Puxar código mais recente
git pull origin main

# Reconstruir contêineres
docker-compose build

# Reiniciar serviços
docker-compose restart
```

---

## Performance & Otimização

### Quanto espaço em disco preciso?

- **Instalação base**: ~500MB (contêineres)
- **Por modelo**: 1-10GB dependendo do modelo
- **Logs**: ~100MB (cresce com o tempo)
- **Recomendação**: 20GB de espaço livre

### Posso limitar o uso de recursos?

Sim! Edite o `docker-compose.yml`:

```yaml
services:
  ollama:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
```

### Qual modelo é mais rápido?

Ranking de velocidade (mais rápido para mais lento):
1. `tinyllama` - ~2-5 segundos por explicação
2. `gemma:7b` - ~5-10 segundos por explicação
3. `mistral` - ~8-15 segundos por explicação
4. `llama2:13b` - ~15-30 segundos por explicação

### Posso usar aceleração GPU?

Sim, se você tiver GPU NVIDIA:

1. Instale o [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)
2. Modifique o `docker-compose.yml`:

```yaml
services:
  ollama:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

---

## Segurança & Privacidade

### Meu kubeconfig está seguro?

Sim:
- Montado como **somente leitura** no contêiner
- Nunca modificado ou exposto
- Usado apenas para acesso à API
- Contêiner está isolado

### Quais dados são coletados?

**Nenhum!** Mekhanikube:
- ❌ Sem telemetria
- ❌ Sem analytics
- ❌ Sem conexões externas (exceto downloads de modelos)
- ❌ Sem compartilhamento de dados

### Posso usar em produção?

Sim, mas:
- ✅ É somente leitura (seguro)
- ✅ Sem modificações no cluster
- ⚠️ Garanta recursos adequados
- ⚠️ Teste em dev/staging primeiro
- ⚠️ Monitore o uso de recursos

### Devo fazer commit do meu arquivo .env?

**NÃO!** O arquivo `.env` pode conter informações sensíveis. Já está no `.gitignore`.

---

## Contribuindo & Suporte

### Como posso contribuir?

Veja [CONTRIBUTING.md](../CONTRIBUTING.md) para:
- Reportar bugs
- Sugerir funcionalidades
- Enviar pull requests
- Melhorar a documentação

### Onde reporto bugs?

Abra uma issue no [GitHub Issues](https://github.com/jorgegabrielti/mekhanikube/issues) com:
- SO e versão do Docker
- Saída de `docker-compose ps`
- Passos para reproduzir
- Mensagens de erro/logs

### Posso solicitar novas funcionalidades?

Sim! Abra uma GitHub Issue com:
- Descrição da funcionalidade
- Caso de uso
- Comportamento esperado
- Exemplo de uso

### Como obtenho ajuda?

1. Verifique este FAQ
2. Leia [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
3. Pesquise [issues existentes](https://github.com/jorgegabrielti/mekhanikube/issues)
4. Abra uma nova issue
5. Participe das discussões

---

## Roadmap & Futuro

### O que está planejado para versões futuras?

- Dashboard Web UI
- Integrações Slack/Teams
- Plugins de analisador customizados
- Rastreamento de análise histórica
- Modo operador Kubernetes
- Suporte multi-cluster

### Posso patrocinar o projeto?

Ainda não, mas fique ligado! Enquanto isso, contribuições e estrelas no GitHub são apreciadas! ⭐

---

## Comparação com Outras Ferramentas

### Mekhanikube vs kubectl

- **kubectl**: Comandos de baixo nível, interpretação manual
- **Mekhanikube**: Análise automatizada com explicações de IA

### Mekhanikube vs K9s

- **K9s**: TUI interativa para gerenciamento de cluster
- **Mekhanikube**: Detecção automatizada de problemas com IA

### Mekhanikube vs Lens

- **Lens**: IDE desktop GUI para Kubernetes
- **Mekhanikube**: Ferramenta CLI com análise de IA

### Mekhanikube vs Prometheus/Grafana

- **Prometheus/Grafana**: Métricas e monitoramento
- **Mekhanikube**: Detecção e explicação de problemas

**Eles se complementam!** Use Mekhanikube para diagnósticos junto com suas ferramentas existentes.

---

## Recursos Adicionais

- 📖 [Documentação de Arquitetura](ARCHITECTURE.md)
- 🔧 [Guia de Solução de Problemas](TROUBLESHOOTING.md)
- 🤝 [Diretrizes de Contribuição](../CONTRIBUTING.md)
- 📝 [Histórico de Mudanças](../CHANGELOG.md)
- 🐙 [Repositório GitHub](https://github.com/jorgegabrielti/mekhanikube)
- 🔗 [Documentação K8sGPT](https://docs.k8sgpt.ai/)
- 🦙 [Documentação Ollama](https://github.com/ollama/ollama)

---

**Não encontrou sua resposta?** Abra uma issue no GitHub!
