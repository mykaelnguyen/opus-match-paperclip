# Opus Match AI — Paperclip Configuration

This repository contains the [Paperclip](https://github.com/paperclipai/paperclip) AI orchestration configuration for **Opus Match AI**, the AI-powered talent marketplace for enterprise healthcare staffing.

## Overview

Paperclip is an open-source AI company orchestration platform that allows you to run a virtual AI company with agents organized in a hierarchy, each with defined roles, responsibilities, and LLM adapters.

## Org Structure

```
CEO (Chief Executive Officer)
├── CTO (Chief Technology Officer)
│   └── Head of Data (Head of Data & AI)
├── CMO (Chief Marketing Officer)
└── Head of Product (Head of Product)
```

| Agent | Role | Adapter | Reports To |
|---|---|---|---|
| CEO | Chief Executive Officer | Claude (local) | — |
| CTO | Chief Technology Officer | Claude (local) | CEO |
| CMO | Chief Marketing Officer | Claude (local) | CEO |
| Head of Product | Head of Product | Claude (local) | CEO |
| Head of Data | Head of Data & AI | Claude (local) | CTO |

## Setup

### Prerequisites

- Node.js 18+
- `npx` (bundled with Node.js)
- An LLM adapter (Claude Code, Codex, Gemini CLI, etc.)

### Quick Start

```bash
# Install and run Paperclip
npx paperclipai run

# Or run the onboarding wizard for first-time setup
npx paperclipai onboard
```

### Importing the Opus Match Company

After starting Paperclip, import the company configuration:

1. Open the Paperclip UI at `http://localhost:3100`
2. Navigate to **Org → Import company**
3. Upload the file from `config/opus-match-company-export.json`

### Configuration

The `config/paperclip-config.json` file contains the server configuration template. Key settings:

- **deploymentMode**: `authenticated` (requires login for all access)
- **exposure**: `public` (accessible from external URLs)
- **database**: Embedded PostgreSQL (no external DB required for local dev)
- **storage**: Local disk (upgrade to S3 for production)

### Environment Variables

Create a `.env` file in your Paperclip instance directory with:

```env
BETTER_AUTH_SECRET=<your-secret-key>
```

Generate a secret with: `openssl rand -base64 32`

## Agent Prompts

Agent prompt templates are stored in `agents/` for version control and review:

- `agents/ceo.md` — CEO prompt template
- `agents/cto.md` — CTO prompt template
- `agents/cmo.md` — CMO prompt template
- `agents/head-of-product.md` — Head of Product prompt template
- `agents/head-of-data.md` — Head of Data & AI prompt template

## Production Deployment

For production, we recommend:

1. **Railway** — Docker container with persistent storage, supports long-running agent heartbeats
2. **AWS ECS** — For teams already on AWS infrastructure
3. **Self-hosted VPS** — Full control with Docker Compose

> **Note:** Vercel is not recommended for Paperclip due to serverless function timeout limits that interrupt agent heartbeats.

## Resources

- [Paperclip GitHub](https://github.com/paperclipai/paperclip)
- [Paperclip Docs](https://paperclip.ing/docs)
- [Opus Match AI](https://opusmatch.ai)
