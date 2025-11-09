# Contributing to mekhanikube 🔧

Thank you for your interest in contributing to mekhanikube!

## How to Contribute

### Reporting Issues
- Use GitHub Issues to report bugs
- Include your OS, Docker version, and Kubernetes version
- Provide steps to reproduce the issue
- Include relevant logs (`docker logs mekhanikube-k8sgpt` or `docker logs mekhanikube-ollama`)

### Suggesting Features
- Open a GitHub Issue with the "enhancement" label
- Describe the use case and expected behavior
- Explain how it would benefit users

### Pull Requests
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Test your changes locally
4. Commit with clear messages (`git commit -m 'Add amazing feature'`)
5. Push to your fork (`git push origin feature/amazing-feature`)
6. Open a Pull Request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/mekhanikube.git
cd mekhanikube

# Start the stack
docker-compose up -d

# Download a model
docker exec mekhanikube-ollama ollama pull gemma:7b

# Test
docker exec mekhanikube-k8sgpt k8sgpt analyze --explain
```

## Code Style

- Shell scripts: Follow ShellCheck recommendations
- Docker: Use multi-stage builds and minimize layers
- Documentation: Keep README.md updated

## Testing

Before submitting a PR:
1. Ensure Docker images build successfully
2. Test with a local Kubernetes cluster
3. Verify all commands in README.md work
4. Check that entrypoint.sh handles edge cases

## Questions?

Open a GitHub Discussion or Issue!

