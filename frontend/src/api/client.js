/**
 * API client for the Campaign Investigation Tracker.
 *
 * Additional fetch functions (campaign detail, health snapshots,
 * investigations) will be added during the workshop as new
 * backend endpoints are built.
 */

const API_BASE = '/api';

/**
 * Generic fetch wrapper with error handling.
 * @param {string} path — API path (prefixed with /api by the Vite proxy)
 */
async function fetchApi(path) {
  const url = `${API_BASE}${path}`;

  const response = await fetch(url);
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
