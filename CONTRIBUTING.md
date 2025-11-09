# Contribuindo para o mekhanikube 🔧

Obrigado pelo seu interesse em contribuir com o mekhanikube!

## Como Contribuir

### Reportando Problemas
- Use GitHub Issues para reportar bugs
- Inclua seu SO, versão do Docker e versão do Kubernetes
- Forneça passos para reproduzir o problema
- Inclua logs relevantes (`docker logs mekhanikube-k8sgpt` ou `docker logs mekhanikube-ollama`)

### Sugerindo Funcionalidades
- Abra uma GitHub Issue com o rótulo "enhancement"
- Descreva o caso de uso e o comportamento esperado
- Explique como isso beneficiaria os usuários

### Pull Requests
1. Faça fork do repositório
2. Crie uma branch de funcionalidade (`git checkout -b feature/funcionalidade-incrivel`)
3. Teste suas alterações localmente
4. Faça commit com mensagens claras (`git commit -m 'Adiciona funcionalidade incrível'`)
5. Envie para seu fork (`git push origin feature/funcionalidade-incrivel`)
6. Abra um Pull Request

### Configuração de Desenvolvimento

```bash
# Clone seu fork
git clone https://github.com/SEU_USUARIO/mekhanikube.git
cd mekhanikube

# Inicie a pilha
docker-compose up -d

# Baixe um modelo
docker exec mekhanikube-ollama ollama pull gemma:7b

# Teste
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain
```

## Estilo de Código

- Scripts Shell: Siga as recomendações do ShellCheck
- Docker: Use builds multi-estágio e minimize camadas
- Documentação: Mantenha o README.md atualizado

## Testes

Antes de enviar um PR:
1. Garanta que as imagens Docker sejam construídas com sucesso
2. Teste com um cluster Kubernetes local
3. Verifique se todos os comandos no README.md funcionam
4. Verifique se o entrypoint.sh trata casos extremos

## Dúvidas?

Abra uma GitHub Discussion ou Issue!

