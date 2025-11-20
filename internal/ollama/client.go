package ollama

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/jorgegabrielti/nautikube/pkg/types"
)

// Client é o cliente HTTP para comunicação com Ollama
type Client struct {
	baseURL    string
	model      string
	httpClient *http.Client
}

// New cria um novo cliente Ollama
func New(baseURL, model string) *Client {
	return &Client{
		baseURL: baseURL,
		model:   model,
		httpClient: &http.Client{
			Timeout: 300 * time.Second, // 5 minutos - LLMs podem demorar, especialmente no primeiro uso
		},
	}
}

// Explain envia um problema para o Ollama e retorna a explicação
func (c *Client) Explain(ctx context.Context, problem *types.Problem, language string) (string, error) {
	prompt := c.buildPrompt(problem, language)

	req := types.OllamaRequest{
		Model:  c.model,
		Prompt: prompt,
		Stream: false,
	}

	body, err := json.Marshal(req)
	if err != nil {
		return "", fmt.Errorf("erro ao criar requisição: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", c.baseURL+"/api/generate", bytes.NewBuffer(body))
	if err != nil {
		return "", fmt.Errorf("erro ao criar HTTP request: %w", err)
	}

	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.httpClient.Do(httpReq)
	if err != nil {
		return "", fmt.Errorf("erro ao fazer requisição: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("ollama retornou status %d: %s", resp.StatusCode, string(bodyBytes))
	}

	var ollamaResp types.OllamaResponse
	if err := json.NewDecoder(resp.Body).Decode(&ollamaResp); err != nil {
		return "", fmt.Errorf("erro ao decodificar resposta: %w", err)
	}

	return ollamaResp.Response, nil
}

// buildPrompt constrói o prompt para o LLM baseado no problema
func (c *Client) buildPrompt(problem *types.Problem, language string) string {
	detailsStr := ""
	if len(problem.Details) > 0 {
		detailsStr = "\nDETALHES TÉCNICOS:\n"
		for _, detail := range problem.Details {
			detailsStr += fmt.Sprintf("- %s\n", detail)
		}
	}

	// Prompt otimizado com estrutura clara e instruções específicas
	return fmt.Sprintf(`Você é um SRE (Site Reliability Engineer) especialista em Kubernetes com 10 anos de experiência em troubleshooting de clusters de produção.

CONTEXTO DO PROBLEMA:
- Tipo de Recurso: %s
- Namespace: %s
- Nome do Recurso: %s
- Erro Detectado: %s%s

TAREFA:
Analise este problema do Kubernetes e forneça uma resposta estruturada e prática em português brasileiro.

FORMATO OBRIGATÓRIO DA RESPOSTA:

1. CAUSA RAIZ (máximo 2 linhas):
   Explique de forma técnica mas clara o que causou este problema específico.

2. IMPACTO (1 linha):
   Descreva o impacto deste problema no cluster e nas aplicações.

3. SOLUÇÃO PASSO-A-PASSO (3-5 passos numerados):
   Liste comandos kubectl específicos e ações práticas para resolver.
   Exemplo: "kubectl logs <pod> -n <namespace>" ou "kubectl describe pod <nome>"

RESTRIÇÕES:
- Máximo 200 palavras no total
- Use comandos kubectl reais e executáveis quando aplicável
- Seja técnico mas compreensível para DevOps intermediários
- Evite explicações genéricas - seja específico para ESTE erro
- Não use jargões desnecessários ou termos em inglês sem tradução
- Priorize soluções que podem ser executadas imediatamente

IMPORTANTE: Responda APENAS com o conteúdo estruturado acima, sem introduções ou conclusões adicionais.`,
		problem.Kind,
		problem.Namespace,
		problem.Name,
		problem.Error,
		detailsStr,
	)
}

// Health verifica se o Ollama está acessível
func (c *Client) Health(ctx context.Context) error {
	req, err := http.NewRequestWithContext(ctx, "GET", c.baseURL+"/api/tags", nil)
	if err != nil {
		return err
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("ollama não está acessível: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("ollama retornou status inválido: %d", resp.StatusCode)
	}

	return nil
}
