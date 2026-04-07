/**
 * API client for the Campaign Investigation Tracker.
 *
 * Additional fetch functions (campaign detail, health snapshots,
 * investigations) will be added during the workshop as new
 * backend endpoints are built.
 */

const API_BASE = '/api';

// TODO [Step 2 — Day 1 / Module 02 — Economics]: When building out additional API functions below,
//   demonstrate model switching during development. Use a stronger model (e.g. Opus) for
//   planning the API client architecture and a cheaper/faster model (e.g. Haiku) for
//   routine implementation like writing repetitive fetch wrappers.
//   "Model choice is a workflow design decision — do not spend premium reasoning on repetitive tasks."

/**
 * Generic fetch wrapper with error handling.
 * @param {string} path — API path (prefixed with /api by the Vite proxy)
 */
async function fetchApi(path, options = {}) {
  const url = `${API_BASE}${path}`;
  const response = await fetch(url, options);
  if (!response.ok) {
    throw new Error(`API error: ${response.status} ${response.statusText}`);
  }
  return response.json();
}

/**
 * Fetch all campaigns.
 */
export async function getCampaigns() {
  return fetchApi('/campaigns');
}

/**
 * Fetch a single campaign with health snapshots.
 * @param {string} id — Campaign ID
 */
export async function getCampaign(id) {
  return fetchApi(`/campaigns/${id}`);
}

/**
 * Fetch health snapshots for a campaign.
 * @param {string} campaignId — Campaign ID
 */
export async function getCampaignHealth(campaignId) {
  return fetchApi(`/campaigns/${campaignId}/health`);
}

async function fetchApiMutate(method, path, body) {
  return fetchApi(path, {
    method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
}

/**
 * Create a new investigation.
 * @param {object} data — Investigation form data
 */
export async function createInvestigation(data) {
  return fetchApiMutate('POST', '/investigations', data);
}

/**
 * Fetch investigations for a campaign.
 * @param {string} campaignId — Campaign ID
 */
export async function getInvestigations(campaignId) {
  return fetchApi(`/campaigns/${campaignId}/investigations`);
}

/**
 * Update an investigation's status.
 * @param {string} id — Investigation ID
 * @param {string} status — New status value
 * @param {string|null} resolutionSummary — Required when status is "Resolved"
 */
export async function updateInvestigationStatus(id, status, resolutionSummary) {
  const body = { status };
  if (resolutionSummary) body.resolution_summary = resolutionSummary;
  return fetchApiMutate('PATCH', `/investigations/${id}/status`, body);
}

// TODO [Step 12 — Day 2 / Module 05 — Production Rollout]: Add getAiRuns(investigationId) function.
//   Fetches AI run records from GET /investigations/{id}/ai-runs.
//   Surfaces AI usage data on the investigation detail view.
