# Opus Match AI — Paperclip Configuration

This repository contains the [Paperclip](https://github.com/paperclipai/paperclip) AI orchestration configuration for **Opus Match AI** (MyLong IO, Inc.), the AI-powered talent marketplace for enterprise healthcare staffing.

**Live Instance:** [https://paperclip-production-b301.up.railway.app](https://paperclip-production-b301.up.railway.app)

---

## Org Structure

```
CEO (Chief Executive Officer)
├── Billy Pham (Chief Technology Officer)
│   └── Hiep Nguyen (Engineering Manager)
├── Paolo La Rosa (Client Lead)
└── Hannah Soto (Executive Assistant & Billing)
```

| Agent | Title | Reports To |
|---|---|---|
| CEO | Chief Executive Officer | — (Board) |
| Billy Pham | Chief Technology Officer | CEO |
| Hiep Nguyen | Engineering Manager | Billy Pham |
| Paolo La Rosa | Client Lead | CEO |
| Hannah Soto | Executive Assistant & Billing | CEO |

---

## Deployment Architecture

The Paperclip instance is deployed on **Railway** using a Docker-based approach. A key technical detail: the Dockerfile replaces the `paperclipai` binary with a wrapper script (`scripts/start.sh`) that generates `config.json` at runtime using Railway environment variables (including `RAILWAY_PUBLIC_DOMAIN`), then calls the real binary. This was necessary because Railway auto-detects and runs the `paperclipai` binary directly, ignoring `CMD`/`ENTRYPOINT` overrides.

### Redeploying

If you need to redeploy from scratch:

1. Create a new Railway project and service from this GitHub repo
2. Add a persistent volume mounted at `/data/paperclip`
3. Set environment variables (see `railway.env.example`)
4. Railway will auto-build and deploy from the Dockerfile

### Environment Variables

In Railway dashboard → **Variables**, ensure these are set:

```
BETTER_AUTH_SECRET=<run: openssl rand -base64 32>
PAPERCLIP_URL=https://<your-railway-domain>.railway.app
PAPERCLIP_AUTH_MODE=public
PORT=3100
```

---

## Connecting Claude (Required for Agent Heartbeats)

Each agent uses the `claude_local` adapter. The Railway server does not have the `claude` CLI installed natively — agents require a Claude API key to function. To activate:

1. Go to any agent → **Configuration** tab
2. Add an environment variable: `ANTHROPIC_API_KEY` = your Anthropic API key
3. Click **Run Heartbeat** to test

---

## Local Development

```bash
# Install Paperclip
npm install -g paperclipai

# Start Paperclip
paperclipai run

# Import company config (first time only)
paperclipai company import ./company-export
```

---

## Repository Structure

```
.
├── Dockerfile              # Railway/Docker deployment
├── railway.toml            # Railway deployment config
├── railway.env.example     # Environment variable template
├── README.md               # This file
├── agents/                 # Agent prompt templates (reference)
│   ├── ceo.md
│   ├── billy-pham.md
│   ├── hiep-nguyen.md
│   ├── paolo-la-rosa.md
│   └── hannah-soto.md
├── company-export/         # Paperclip CLI export (importable)
│   ├── .paperclip.yaml
│   ├── COMPANY.md
│   ├── README.md
│   ├── agents/
│   └── images/
├── config/                 # Config templates
├── scripts/
│   ├── start.sh            # Wrapper script (replaces paperclipai binary)
│   ├── paperclipai-wrapper.sh
│   └── setup-railway.sh    # Post-deployment setup script
└── config.json             # Generated config reference
```

---

## Active Clients

Serenity Senior Living · Juniper Communities · Sage Oak Assisted Living · Maplewood Health · Riverbend Care · Crestview Living · Harmony Health Services · Oakdale Senior Care · Sunrise Wellness Group · Pinnacle Home Health

---

## Resources

- [Paperclip GitHub](https://github.com/paperclipai/paperclip)
- [Paperclip Docs](https://paperclip.ing/docs)
- [Opus Match AI](https://opusmatch.ai)

---

*Maintained by Michael Nguyen (CEO, Opus Match AI)*
