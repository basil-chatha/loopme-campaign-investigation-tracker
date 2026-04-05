-- =============================================================================
-- Campaign Investigation Tracker — Initial Schema
-- =============================================================================

CREATE TABLE IF NOT EXISTS campaigns (
  id              text PRIMARY KEY,
  campaign_code   text NOT NULL UNIQUE,
  name            text NOT NULL,
  advertiser      text NOT NULL,
  status          text NOT NULL,
  objective       text NOT NULL,
  channel         text,
  start_date      date NOT NULL,
  end_date        date NOT NULL,
  budget_usd      numeric(12,2) NOT NULL,
  owner_name      text,
  region          text,
  created_at      timestamptz NOT NULL,
  updated_at      timestamptz NOT NULL
);

CREATE TABLE IF NOT EXISTS campaign_health (
  id                text PRIMARY KEY,
  campaign_id       text NOT NULL REFERENCES campaigns(id),
  snapshot_at       timestamptz NOT NULL,
  impressions       integer,
  clicks            integer,
  ctr               numeric(6,3) NOT NULL,
  viewability       numeric(6,2) NOT NULL,
  completion_rate   numeric(6,2),
  spend_usd         numeric(12,2) NOT NULL,
  budget_pacing_pct numeric(6,2),
  delivery_rate_pct numeric(6,2),
  anomaly_flag      boolean,
  anomaly_reason    text,
  delivery_note     text
);

CREATE TABLE IF NOT EXISTS investigations (
  id                  text PRIMARY KEY,
  campaign_id         text NOT NULL REFERENCES campaigns(id),
  source_snapshot_id  text REFERENCES campaign_health(id),
  issue_type          text NOT NULL,
  severity            text NOT NULL,
  status              text NOT NULL,
  owner_name          text,
  question            text NOT NULL,
  hypothesis          text NOT NULL,
  next_action         text NOT NULL,
  resolution_summary  text,
  opened_at           timestamptz NOT NULL,
  updated_at          timestamptz NOT NULL,
  resolved_at         timestamptz
);

CREATE TABLE IF NOT EXISTS investigation_evidence (
  id                text PRIMARY KEY,
  investigation_id  text NOT NULL REFERENCES investigations(id),
  snapshot_id       text REFERENCES campaign_health(id),
  evidence_type     text NOT NULL,
  title             text NOT NULL,
  summary           text NOT NULL,
  metric_name       text,
  metric_value      numeric(12,4),
  metric_unit       text,
  source_label      text,
  source_ref        text,
  captured_at       timestamptz NOT NULL,
  captured_by       text,
  is_key_evidence   boolean DEFAULT false,
  sort_order        integer
);

CREATE TABLE IF NOT EXISTS ai_runs (
  id                      text PRIMARY KEY,
  investigation_id        text NOT NULL REFERENCES investigations(id),
  model                   text NOT NULL,
  task_type               text NOT NULL,
  input_tokens            integer,
  output_tokens           integer,
  estimated_cost_usd      numeric(10,4),
  latency_ms              integer,
  prompt_summary          text,
  recommendation_summary  text,
  created_at              timestamptz NOT NULL
);
