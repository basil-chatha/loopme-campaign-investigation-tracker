# Plan: Fix codex-review.md model, generality, and MCP config

## Context

The `/codex-review` command was copied from a user-level skill but has three problems:
1. Hardcodes `gpt-5.3-codex`, a deprecated model alias — user's codex config.toml uses `gpt-5.4` and has an explicit migration `"gpt-5.3-codex" = "gpt-5.4"`
2. Missing `$ARGUMENTS` support and YAML frontmatter that every other command in `.claude/commands/` uses
3. Contains stop-hook queue file machinery (`/tmp/codex_review_queue_...`) that will never be used — there are no hooks associated with this command

The `.mcp.json` codex entry (`"command": "codex", "args": ["mcp-server"]`) is correct — no changes needed there.

## Changes (single file: `.claude/commands/codex-review.md`)

### 1. Add YAML frontmatter
Insert before current content, matching `spec-developer.md` convention:
```yaml
---
description: Reviews code changes from 3 parallel Codex (GPT-5.4) reviewers for bugs, CLAUDE.md compliance, and code quality
argument-hint: "[file or directory paths to review]"
---
```

### 2. Update model `gpt-5.3-codex` → `gpt-5.4` (two locations)
- **Header paragraph** (line 2): `"Codex (GPT-5.3)"` → `"Codex (GPT-5.4)"`
- **Codex Configuration block** (line 98): `model: "gpt-5.3-codex"` → `model: "gpt-5.4"` with a comment noting the user can omit `model` to inherit the codex config.toml default

### 3. Add `$ARGUMENTS` as top-priority file source and remove queue file machinery
Rewrite "Gathering Changed Files" to a 2-tier priority:
1. **`$ARGUMENTS`** (explicit paths from `/codex-review src/app.py backend/`) — if non-empty, use directly; expand directories recursively; validate paths exist
2. **Git diff fallback** (no arguments provided) — existing behavior: `git diff HEAD`, then `git diff HEAD~1`, then ask user

Remove all references to:
- Queue file (`/tmp/codex_review_queue_${CLAUDE_SESSION_ID:-default}.txt`)
- Stop hook triggers
- Queue file cleanup (`rm -f /tmp/codex_review_queue_...`)

### 4. Simplify Skip Behavior and Important Notes
- Remove the "Automatic trigger" / queue-file-present case from Skip Behavior
- Keep only the direct invocation case: if all changed files are non-code, ask "Run review anyway?"
- Remove queue file mentions from "Important Notes" and "Cleanup" sections
- Remove the entire "Cleanup" section (it only deleted the queue file)

### 5. Update Error Handling
- Remove "Non-git repo with no queue file" case
- Simplify to: if not a git repo and no `$ARGUMENTS`, ask user which files to review

## Files
- **Modify**: `.claude/commands/codex-review.md`
- **No changes**: `.mcp.json` (codex server config is correct)

## Verification
1. Run `/codex-review` — should fall back to git diff
2. Run `/codex-review backend/app/main.py` — should review that specific file
3. Confirm the Codex MCP tool calls use `model: "gpt-5.4"` in the spawned reviewer sessions
