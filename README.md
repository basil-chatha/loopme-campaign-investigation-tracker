# Campaign Investigation Tracker

A lightweight campaign operations tool for triaging underperforming ad campaigns — built live during the Claude Code Masterclass.

## What this is

This repo is the **starting skeleton** for a hands-on, instructor-led build. Over two days, the class will turn it into a working investigation tracker using Claude Code as the primary development workflow.

The finished product lets an operator browse campaigns, spot health issues, open structured investigations, capture evidence, and progress issues through to resolution.

## Tech stack

| Layer | Technology |
|-------|------------|
| Frontend | React, Tailwind CSS, shadcn/ui |
| Backend | FastAPI (Python) |
| Database | PostgreSQL (Supabase) |

## Repo structure

```text
frontend/          → React app shell with routing and baseline styling
backend/           → FastAPI server with health endpoint and DB connectivity
```

## What's already here

- App shell, routing, and baseline component scaffolding
- FastAPI bootstrapped with a health check endpoint
- Database schema and seed data for realistic demo scenarios
- Basic test harnesses (runnable out of the box)
- Local startup flow that works without additional setup

## Data model (seeded)

The seed data provides a small, curated dataset that tells a workshop story — not a production-scale fixture. Five tables are pre-seeded in the database:

- **Campaigns** — mix of healthy, unhealthy, and ambiguous ad campaigns
- **Campaign Health** — time-series snapshots with metrics like CTR, viewability, spend, and pacing
- **Investigations** — structured triage records with question, hypothesis, status, and next action
- **Investigation Evidence** — typed evidence items (metrics, delivery notes, operator notes, QA checks)
- **AI Runs** — lightweight log of model usage tied to investigations (for economics discussion)

The backend currently maps only `campaigns` and `campaign_health` as ORM models. The remaining models, schemas, and API routes will be built during the workshop.

## What we'll build together

Over the course of the workshop, this skeleton becomes a working product while demonstrating Claude Code workflows:

1. Surface campaign health data and make a first visible change
2. Add the AI usage model scaffold and discuss token economics
3. Build a campaign detail page with investigation entry point
4. Implement investigation creation, evidence capture, and persistence end to end
5. Add investigation status progression (New → Investigating → Needs Action → Resolved)
6. Surface AI usage and recommendation data
7. Layer in shared repo standards, skills, hooks, and automation

## Getting started

### Prerequisites

- Python 3.10+ and [uv](https://docs.astral.sh/uv/)
- [Bun](https://bun.sh/)
- [Supabase CLI](https://supabase.com/docs/guides/cli) and Docker (for local Supabase)

### 1. Start local Supabase

```bash
supabase start
```

This starts PostgreSQL, Auth, and other Supabase services in Docker. The seed data in `supabase/seed.sql` is applied automatically. Note the `DB URL` from the output — you'll need it next.

### 2. Start the backend

```bash
cd backend
cp .env.example .env        # then set DATABASE_URL to the DB URL from `supabase start`
uv venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
uv pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

API docs will be at `http://localhost:8000/docs`.

### 3. Start the frontend

```bash
cd frontend
bun install
bun run dev
```

Opens at `http://localhost:5173`. The Vite dev server proxies `/api` requests to the backend.

### 4. Run backend tests

```bash
cd backend
uv run pytest
```

## MCP servers (Claude Code)

This repo includes a `.mcp.json` that configures five MCP servers for use with Claude Code. After cloning, follow these steps to make sure they work.

### 1. Install prerequisites

- **Node.js** — required for `npx`, which launches the Playwright and Exa servers
- **Codex CLI** — install globally: `npm install -g @openai/codex`

### 2. Set environment variables

Add these to your shell profile or a local `.env` file:

```bash
export OPENAI_API_KEY="your-openai-key"       # required by Codex CLI
export EXA_API_KEY="your-exa-key"             # required by Exa MCP — get one at https://dashboard.exa.ai
```

### 3. Cloud MCPs (no local setup needed)

**Atlassian** and **Linear** are remote HTTP servers. Claude Code will prompt you to authenticate via OAuth the first time you use them — no keys or installs required.

### 4. Local MCPs (auto-launched by Claude Code)

| Server | What it runs | Requires |
|--------|-------------|----------|
| Playwright | `npx @playwright/mcp@latest` | Node.js only |
| Codex | `codex mcp-server` | Codex CLI installed globally + `OPENAI_API_KEY` |
| Exa | `npx exa-mcp-server` | Node.js + `EXA_API_KEY` |

### 5. Verify

Open Claude Code in the project directory and run:

```text
/mcp
```

All five servers should show as connected.

## Workshop context

This project is part of the [LoopMe Claude Code Masterclass](https://realaization.com). It is intentionally scoped to stay small, legible, and demo-friendly — not to be a production campaign ops platform.
