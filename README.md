# Opus Match AI — Paperclip Deployment

AI-powered talent marketplace for enterprise healthcare staffing, orchestrated by [Paperclip](https://github.com/paperclipai/paperclip).

## Live Instance

**URL**: https://paperclip-production-b301.up.railway.app

## Architecture

This deployment uses **Claude Max subscription** (not API billing) via the `claude_local` adapter. The Claude CLI is installed in the Docker image and must be authenticated with your Claude Max subscription on the Railway container.

### Agent Configuration (Best Practices Applied)

Each agent is configured with a three-file architecture based on production-tested patterns from the Paperclip community:

| File | Purpose |
|---|---|
| `AGENTS.md` | Identity, team roster, context, and file-reading instructions |
| `SOUL.md` | Strict boundaries, anti-patterns, and escalation triggers |
| `HEARTBEAT.md` | Numbered wake-cycle checklist with mandatory self-check |

### Org Chart

```
CEO (Michael Nguyen)
├── Billy Pham (CTO)
│   └── Hiep Nguyen (Engineering Manager)
├── Paolo La Rosa (Client Lead)
└── Hannah Soto (EA/Billing)
```

### Company-Level Files

| File | Purpose |
|---|---|
| `COMPANY.md` | Company identity and values |
| `PROJECT-INVENTORY.md` | Source of truth for what exists (prevents duplicate work) |

## Claude Max Setup

After Railway deploys, you must authenticate the Claude CLI on the container:

1. Open the Railway dashboard
2. Navigate to the Paperclip service
3. Open the **Shell** tab (or use `railway shell`)
4. Run: `claude login`
5. Follow the prompts to authenticate with your Claude Max subscription
6. Verify: `claude --version`

**Important**: Do NOT set `ANTHROPIC_API_KEY` in the agent environment variables. This forces the adapter to use your subscription instead of API billing.

## Environment Variables (Railway)

| Variable | Value |
|---|---|
| `NODE_ENV` | `production` |
| `PORT` | `3100` |

## Repository Structure

```
├── Dockerfile                    # Docker build with Paperclip + Claude CLI
├── company-export/               # Importable Paperclip company package
│   ├── .paperclip.yaml           # Agent adapter and heartbeat config
│   ├── COMPANY.md                # Company identity
│   ├── PROJECT-INVENTORY.md      # Source of truth for what exists
│   └── agents/                   # Per-agent configuration files
│       ├── ceo/                  # AGENTS.md, SOUL.md, HEARTBEAT.md
│       ├── billy-pham/           # AGENTS.md, SOUL.md, HEARTBEAT.md
│       ├── hiep-nguyen/          # AGENTS.md, SOUL.md, HEARTBEAT.md
│       ├── paolo-la-rosa/        # AGENTS.md, SOUL.md, HEARTBEAT.md
│       └── hannah-soto/          # AGENTS.md, SOUL.md, HEARTBEAT.md
├── config/                       # Paperclip server configuration
├── scripts/                      # Startup and setup scripts
└── agents/                       # Agent prompt template reference docs
```
