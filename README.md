# Opus Match AI — Paperclip Configuration

This repository contains the [Paperclip](https://github.com/paperclipai/paperclip) AI orchestration configuration for **Opus Match AI** (MyLong IO, Inc.), the AI-powered talent marketplace for enterprise healthcare staffing.

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

## Deploying to Railway (Permanent Hosting)

### Prerequisites

- [Railway account](https://railway.app) (free tier works)
- [Railway CLI](https://docs.railway.app/develop/cli): `npm install -g @railway/cli`

### Step 1 — Create a Railway Project

```bash
railway login
railway init
# Select "Empty Project" when prompted
```

### Step 2 — Add a Persistent Volume

In the Railway dashboard:
1. Go to your service → **Volumes**
2. Add a volume mounted at `/data/paperclip`

### Step 3 — Set Environment Variables

In Railway dashboard → **Variables**, add:

```
BETTER_AUTH_SECRET=<run: openssl rand -base64 32>
PAPERCLIP_URL=https://<your-railway-domain>.railway.app
PAPERCLIP_AUTH_MODE=public
PORT=3100
```

### Step 4 — Deploy

```bash
railway up
```

### Step 5 — Import Opus Match Company Config

After the first deployment, run:

```bash
PAPERCLIP_URL=https://<your-railway-domain>.railway.app bash scripts/setup-railway.sh
```

Then visit your Railway URL, find the `board-claim` URL in the Railway logs, and claim admin ownership.

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

## Connecting Claude

Each agent uses the `claude_local` adapter. To activate:

1. Go to any agent → **Configuration** tab
2. Set your Anthropic API key in the environment variables
3. Click **Run Heartbeat** to test

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
└── scripts/
    └── setup-railway.sh    # Post-deployment setup script
```

---

## Active Clients

Host Healthcare · GHR Healthcare · HAN Staff · Concentric Healthcare · WWHS · CrossMed · Focus Staff (Elite365) · Pioneer Healthcare · Recovered Health

---

## Resources

- [Paperclip GitHub](https://github.com/paperclipai/paperclip)
- [Paperclip Docs](https://paperclip.ing/docs)
- [Opus Match AI](https://opusmatch.ai)

---

*Maintained by Michael Nguyen (CEO, Opus Match AI)*
