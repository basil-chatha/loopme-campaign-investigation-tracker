# Campaign Investigation Tracker — Production Rollout Plan

## What production-ready means

A team is not production-ready because it used Claude Code successfully once. Production-ready means:

- Shared repo standards exist and are maintained
- Core workflows are documented and repeatable
- At least one shared skill is owned and reviewed
- Quality or safety guardrails are enforced (not just documented)
- Parallel work has clear boundaries
- Metrics and review cadence are defined

## Minimum viable team setup

Before rolling out broadly, confirm every item in this checklist is in place.

| Asset | Status | Location |
|---|---|---|
| Shared `CLAUDE.md` | Done | `CLAUDE.md` (root) |
| Project-scoped MCP config | Done | `.mcp.json` |
| Shared skill | Done | `.claude/skills/investigation-triage/SKILL.md` |
| Safety guardrail hook | Done | `.claude/hooks/safety-guard.sh` (configured in `.claude/settings.json`) |
| Approved parallel workflow | Done | Investigation status progression (backend + frontend + tests) |
| Custom review agent | Done | `.claude/agents/investigation-reviewer.md` |
| Shared command | Done | `.claude/commands/investigation-plan.md` |
| KPI owner | Assign | See Ownership table below |
| Pilot plan | Done | `docs/pilot-plan.md` |

This is the minimum operating system, not the final state.

## Ownership model

Every shared asset needs a named owner or it will drift.

| Artifact | Owner | Review cadence |
|---|---|---|
| `CLAUDE.md` | Senior engineer / tech lead | Sprint retro or monthly |
| Shared skills (`investigation-triage`) | Workflow owner | When the workflow changes |
| MCP config (`.mcp.json`) | Platform or repo maintainer | When auth/tooling changes |
| Hooks and guardrails (`safety-guard.sh`) | Platform or DevOps lead | Quarterly or on stack change |
| Custom agents (`investigation-reviewer`) | Domain expert | When investigation model changes |
| KPI tracking and reporting | Manager or program owner | Weekly during pilot, then monthly |

If ownership is vague, rollout quality will be vague too.

## Pilot-ready vs not-yet-production inventory

### Pilot-ready (can operate in a narrow team workflow today)

- Campaign list with health indicators
- Campaign detail with health snapshots
- Investigation creation with structured fields (question, hypothesis, owner, next_action)
- Investigation detail page with AI usage card
- Investigation status progression (New -> Investigating -> Needs Action -> Resolved)
- AI economics scaffold (AiRun model, endpoints, frontend display)
- Shared `CLAUDE.md` with conventions, approval boundaries, and workflow rules
- Shared skill for investigation triage
- Safety hook blocking dangerous Bash commands
- Custom review agent for investigation domain changes
- Pilot plan with KPI baselines

### Not yet production-ready (requires further work before broader rollout)

| Gap | Risk if ignored | Decision |
|---|---|---|
| No authentication or RBAC | All users share full access | Add before multi-team rollout |
| No evidence capture UI | Evidence must be logged outside the app | Build when pilot team requests it |
| Tests are connectivity-only | Regressions may not be caught | Add integration tests incrementally |
| No background jobs or notifications | Manual checking required | Add post-pilot if justified by usage |
| No CI/CD pipeline | Deployment is manual | Add when team size exceeds pilot |
| No audit trail | No history of who changed what in the UI | Add before compliance review |

### Should not be standardized yet

- Complex external integrations (ad servers, DSPs)
- Broad analytics or reporting dashboards
- Multi-team or cross-functional rollout
- Performance optimization or horizontal scaling

## 30/60/90-day rollout

### 30 days — Validate

- Run the investigation workflow repeatedly with the pilot team
- Refine `CLAUDE.md` and shared standards based on observed failures
- Measure baseline KPIs: investigation cycle time, evidence items per investigation, AI cost per investigation
- Confirm ownership table is filled in and owners are active
- Log every breakdown in instructions, tooling, or approvals

### 60 days — Harden

- Promote the `investigation-triage` skill based on real usage feedback
- Add one additional automation or guardrail justified by evidence (e.g., post-edit test runner)
- Formalize approval boundaries: what requires human review, what can be automated
- Expand to a second workflow or team only if the first is getting repeatable value
- Review and update `CLAUDE.md` based on 30-day learnings

### 90 days — Decide

- Compare KPI results against 30-day baselines
- Decide what to standardize, what to keep experimental, and what to stop
- Create a measured recommendation for broader adoption with evidence, not anecdotes
- If expanding: document the onboarding path for new teams

## KPI review cadence

Review weekly during the pilot, monthly after.

Questions for each review:

- Which workflows are actually being used?
- Where are approvals slowing things down productively vs wastefully?
- Which shared instructions are unclear or stale?
- Are skills being invoked reliably?
- Are outcomes improving enough to justify continued investment?
- What is the AI cost trend per investigation?

The point of review is to improve the operating system, not to defend a fixed design.

## Decision gates

### What can be automated now

- Blocking dangerous Bash commands (safety-guard hook)
- Investigation triage via shared skill
- Domain-specific code review via investigation-reviewer agent
- Status progression (forward-only, enforced by backend)

### What still requires human approval

- Schema or migration changes
- Modifications to `supabase/migrations/` or `supabase/seed.sql`
- Investigation resolutions (workflow owner review)
- Changes to shared standards (`CLAUDE.md`, skills, hooks)
- Expanding beyond the pilot scope

### What stays experimental

- AI recommendation summaries in investigations
- Parallel workflow patterns beyond status progression
- Background agent usage for autonomous review

### What should not be standardized yet

- Authentication and RBAC patterns (wait for multi-team requirements)
- CI/CD integration (wait for team size growth)
- External API integrations (wait for proven workflow value)
