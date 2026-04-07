Analyze and plan an investigation-related change: $ARGUMENTS

## Step 1 — Understand current state

Read these files to understand the investigation domain model and existing patterns:

- `backend/app/models.py` — ORM models (Investigation, InvestigationEvidence, AiRun, Campaign, CampaignHealth)
- `backend/app/schemas.py` — Pydantic request/response schemas
- `backend/app/routers/investigations.py` — Investigation CRUD endpoints
- `backend/app/routers/campaigns.py` — Campaign endpoints including investigation listing
- `frontend/src/pages/CampaignDetail.jsx` — Investigation form and evidence display
- `frontend/src/api/client.js` — API client functions

## Step 2 — Identify affected files

Based on the requested change, list every file that would need modification. Group them:

- **Backend model/schema changes** (may require migration — flag for approval)
- **Backend router changes** (new or modified endpoints)
- **Frontend component/page changes**
- **API client changes**
- **Test changes** (new tests in `backend/tests/`)

## Step 3 — Propose approach

Write a concise implementation plan following all conventions in CLAUDE.md (coding conventions, entity ID patterns, investigation workflow rules, and testing expectations).

## Step 4 — List risks and approval gates

Flag anything that falls under the approval boundaries in CLAUDE.md. Also flag new dependencies, breaking API changes, or changes to the status progression or evidence type vocabulary.
