# Plan: Add MCP setup instructions to README

## Context
The project's `.mcp.json` configures five MCP servers. When someone clones this repo for the workshop, they need to know what to install and how to verify everything works. The README currently has no MCP setup section.

## Change
Add a new section `## MCP servers (Claude Code)` to `README.md` after the "Run backend tests" block (line ~103) and before "## Workshop context" (line ~104).

### Content to add (verified against docs)

**Prerequisites for stdio MCPs:**
- **Node.js** — needed for `npx` (runs Playwright and Exa servers)
- **Codex CLI** — `npm install -g @openai/codex` (requires `OPENAI_API_KEY` env var)

**API keys needed:**
- `EXA_API_KEY` — get from [exa.ai dashboard](https://dashboard.exa.ai); set in shell env since `.mcp.json` references `${EXA_API_KEY}`
- `OPENAI_API_KEY` — needed for Codex CLI

**Cloud/HTTP MCPs (no local setup):**
- Atlassian and Linear are remote servers — they authenticate via Claude Code's OAuth flow on first use

**Local/stdio MCPs (auto-launched by Claude Code):**
- Playwright (`npx @playwright/mcp@latest`) — no API key, just needs Node.js
- Codex (`codex mcp-server`) — needs the CLI installed globally + `OPENAI_API_KEY`
- Exa (`npx exa-mcp-server`) — needs `EXA_API_KEY` in env

**Verification step:**
- Open Claude Code in the project directory and type `/mcp` to confirm all servers show as connected

## File to modify
- **`README.md`** — insert new section at ~line 103, before `## Workshop context`

## Verification
- Read the updated README and confirm accuracy against `.mcp.json`
- Confirm env var names match what's in the config
