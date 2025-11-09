# Changelog

All notable changes to mekhanikube will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-09

### Added
- Initial release of mekhanikube 🔧
- Docker Compose setup with K8sGPT and Ollama
- Automatic kubeconfig adjustment for Docker containers
- Auto-configuration of K8sGPT auth on startup
- Support for gemma:7b model (default)
- Persistent volumes for models and configuration
- Comprehensive README with setup and usage instructions
- MIT License

### Features
- AI-powered Kubernetes cluster analysis
- Local LLM integration (no external API calls)
- Problem detection across multiple K8s resource types
- Automatic explanations and solutions via Ollama
- Filter support (Pod, Service, ConfigMap, Deployment, etc)
- Namespace-scoped analysis
- Windows/Linux/macOS support via Docker

### Components
- K8sGPT: Built from official source (latest)
- Ollama: Official image (latest)
- Models: gemma:7b (5GB)
- Base images: golang:1.23-alpine, alpine:latest

[1.0.0]: https://github.com/YOUR_USERNAME/mekhanikube/releases/tag/v1.0.0

