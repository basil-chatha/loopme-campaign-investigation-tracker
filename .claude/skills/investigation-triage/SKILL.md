---
name: investigation-triage
description: >
  Triage a campaign investigation by reviewing its status, evidence completeness,
  field quality, and suggesting the next action. Use when asked to assess an
  investigation, check whether evidence is complete, review investigation quality,
  determine whether an investigation is ready to progress to the next status, or
  evaluate whether a resolution is well-documented. Triggers on phrases like
  "triage investigation", "check evidence", "review investigation", "is this
  ready to resolve", "assess investigation quality", or any request to evaluate
  the state of a campaign investigation.
---

# Investigation Triage

Triage a campaign investigation by assessing its current state against domain expectations.
This is a read-only review workflow — it never modifies data.

## Step 1 — Identify the target investigation

Read the domain model to understand the data structures:
- `backend/app/models.py` — Investigation, InvestigationEvidence, AiRun ORM models
- `backend/app/schemas.py` — Pydantic schemas with field types and validation

Then locate the target investigation. The user may provide:
- An investigation ID (e.g., `inv_3001`)
- A campaign ID (find its investigations)
- A description (match by issue type or status)

Look for investigation data in:
- `supabase/seed.sql` — seed data with full investigation + evidence records
- `backend/app/routers/investigations.py` — API endpoints for live data access

## Step 2 — Assess field quality

Check each core investigation field against quality criteria:

| Field | Good | Needs improvement |
|---|---|---|
| `question` | Specific, testable, scoped to one issue | Vague ("why is this bad?") or too broad |
| `hypothesis` | Concrete, falsifiable cause with a mechanism | Generic ("something is wrong") |
| `owner_name` | Named person assigned | Missing or placeholder |
| `next_action` | Actionable, specific step with clear outcome | Vague ("look into it") or missing |
| `issue_type` | One of: Low CTR, Underdelivery, Creative Fatigue, Data Discrepancy, Low Viewability | Unrecognized type |
| `severity` | Appropriate given the health snapshot data | Misaligned with actual metrics |

## Step 3 — Check evidence completeness

Count and categorize evidence items by type (Metric, Delivery Note, Operator Note, QA Check, Recommendation), then apply the expected evidence profile for the investigation's current status:

**New** — At minimum, the triggering metric or delivery note that flagged the issue should exist. Without this, the investigation lacks a factual starting point.

**Investigating** — Supporting metrics beyond the initial trigger, plus at least one operator note showing active human engagement. Investigations stuck in this status with only the original metric suggest stalled work.

**Needs Action** — A recommendation (AI-generated or expert) with supporting evidence. The recommendation should be grounded in metrics and observations, not speculation. If no recommendation exists, the investigation may not be ready for this status.

**Resolved** — The `resolution_summary` field must be populated. At least one evidence item should be marked `is_key_evidence = true`. The `resolved_at` timestamp should be set.

Also check:
- Are evidence `source_ref` values traceable (not empty)?
- Do metric evidence items have `metric_name`, `metric_value`, and `metric_unit` populated?
- Is evidence chronologically ordered (via `sort_order` or `captured_at`)?

## Step 4 — Evaluate status appropriateness

Determine whether the current status is justified:

- Does the evidence collected match expectations for the current status (from Step 3)?
- Is the investigation potentially ready to advance to the next status in the progression: New -> Investigating -> Needs Action -> Resolved?
- Has the investigation been in its current status for an unusually long time (compare `opened_at` / `updated_at` with current date)?
- If status is Resolved: is `resolution_summary` present and is `resolved_at` set?

Flag if the status appears premature (evidence insufficient) or overdue (evidence supports advancement).

## Step 5 — Output the triage report

Produce a structured report using this format:

```bash
## Investigation Triage Report

**Investigation:** [id] | **Campaign:** [campaign_id] | **Status:** [status]
**Issue Type:** [issue_type] | **Severity:** [severity] | **Owner:** [owner_name]

### Field Quality
- Question: [PASS/NEEDS IMPROVEMENT] — [brief note]
- Hypothesis: [PASS/NEEDS IMPROVEMENT] — [brief note]
- Next Action: [PASS/NEEDS IMPROVEMENT] — [brief note]
- Owner: [ASSIGNED/MISSING]

### Evidence Completeness
- Expected for [status] status: [what is expected]
- Found: [count] evidence items ([list types present])
- Missing: [what is missing, if anything]
- Verdict: [COMPLETE/INCOMPLETE]

### Status Assessment
- Current status [status] is [APPROPRIATE/PREMATURE/OVERDUE]
- [Reasoning]

### Recommended Next Action
[One specific, actionable recommendation for what should happen next]

### Severity Check
[Is the assigned severity consistent with the health data? Flag if misaligned.]
```

Keep findings concise. Each section should be 1-3 lines, not paragraphs. The recommended next action should be the single most important thing to do, not a list of suggestions.
