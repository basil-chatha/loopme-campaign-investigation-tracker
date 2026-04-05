# Campaign Investigation Tracker

A lightweight campaign operations tool for triaging underperforming ad campaigns — built live during the Claude Code Masterclass.

## What this is

This repo is the **starting skeleton** for a hands-on, instructor-led build. Over two days, the class will turn it into a working investigation tracker using Claude Code as the primary development workflow.

The finished product lets an operator browse campaigns, spot health issues, open structured investigations, capture evidence, and progress issues through to resolution.

## Tech stack

| Layer | Technology |
|-------|------------|
| Frontend | Angular |
| Backend | FastAPI (Python) |
| Database | PostgreSQL (Supabase) |

## Repo structure

```
frontend/          → Angular app shell with routing and baseline styling
backend/           → FastAPI server with health endpoint and DB connectivity
```

## What's already here

- App shell, routing, and baseline component scaffolding
- FastAPI bootstrapped with a health check endpoint
- Database schema and seed data for realistic demo scenarios
- Basic test harnesses (runnable out of the box)
- Local startup flow that works without additional setup

## Data model (seeded)

The seed data provides a small, curated dataset that tells a workshop story — not a production-scale fixture.

- **Campaigns** — mix of healthy, unhealthy, and ambiguous ad campaigns
- **Campaign Health** — time-series snapshots with metrics like CTR, viewability, spend, and pacing
- **Investigations** — structured triage records with question, hypothesis, status, and next action
- **Investigation Evidence** — typed evidence items (metrics, delivery notes, operator notes, QA checks)
- **AI Runs** — lightweight log of model usage tied to investigations (for economics discussion)

## What we'll build together

Over the course of the workshop, this skeleton becomes a working product while demonstrating Claude Code workflows:

1. Surface campaign health data and make a first visible change
2. Implement campaign detail pages and investigation entry points
3. Build the full investigation creation and evidence capture flow
4. Add investigation status progression (New → Investigating → Needs Action → Resolved)
5. Surface AI usage and recommendation data
6. Layer in shared repo standards, skills, hooks, and automation

## Getting started

```bash
# Start the backend
cd backend
# (setup instructions provided in class)

# Start the frontend
cd frontend
# (setup instructions provided in class)
```

Detailed environment setup and secrets configuration will be handled at the start of the session.

## Workshop context

This project is part of the [LoopMe Claude Code Masterclass](https://realaization.com). It is intentionally scoped to stay small, legible, and demo-friendly — not to be a production campaign ops platform.
