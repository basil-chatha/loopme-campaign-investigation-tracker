-- =============================================================================
-- Campaign Investigation Tracker — Seed Data
-- =============================================================================
-- Designed for the LoopMe Claude Code Masterclass workshop demo.
-- Small, curated, deterministic. Supports the full investigation workflow.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 0. Schema (idempotent — safe to re-run)
-- ---------------------------------------------------------------------------

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


-- ---------------------------------------------------------------------------
-- 1. Campaigns  (10 rows)
-- ---------------------------------------------------------------------------
-- Mix: 3 healthy, 4 unhealthy, 2 mixed/ambiguous, 1 completed
-- ---------------------------------------------------------------------------

INSERT INTO campaigns (id, campaign_code, name, advertiser, status, objective, channel, start_date, end_date, budget_usd, owner_name, region, created_at, updated_at) VALUES

-- Healthy campaigns
('cmp_1001', 'LM-CTV-001', 'Spring Streaming Awareness',       'Acme Retail',        'Active',    'Awareness',   'CTV',     '2026-04-01', '2026-05-15', 120000.00, 'Jordan Lee',   'US',  '2026-04-01T09:00:00Z', '2026-04-04T09:00:00Z'),
('cmp_1002', 'LM-DIS-007', 'Brand Safety Display Push',         'GreenLeaf Foods',    'Active',    'Traffic',     'Display', '2026-03-15', '2026-04-30', 65000.00,  'Priya Sharma', 'EU',  '2026-03-15T09:00:00Z', '2026-04-04T09:00:00Z'),
('cmp_1003', 'LM-VID-022', 'Summer Video Blitz',                'Pinnacle Sports',    'Active',    'Video Views', 'Video',   '2026-03-25', '2026-05-10', 95000.00,  'Marcus Webb',  'US',  '2026-03-25T09:00:00Z', '2026-04-04T09:00:00Z'),

-- Unhealthy campaigns
('cmp_1004', 'LM-VID-014', 'Q2 Product Launch Video',           'Northstar Mobile',   'Active',    'Video Views', 'Video',   '2026-03-20', '2026-05-01', 85000.00,  'Riley Chen',   'UK',  '2026-03-20T09:00:00Z', '2026-04-04T09:00:00Z'),
('cmp_1005', 'LM-DIS-031', 'Retargeting Conversion Wave',       'UrbanNest Interiors','Active',    'Conversion',  'Display', '2026-03-10', '2026-04-20', 48000.00,  'Sam Okafor',   'US',  '2026-03-10T09:00:00Z', '2026-04-04T09:00:00Z'),
('cmp_1006', 'LM-CTV-009', 'Connected TV Reach Boost',          'Voyage Airlines',    'Active',    'Awareness',   'CTV',     '2026-03-18', '2026-04-25', 110000.00, 'Jordan Lee',   'US',  '2026-03-18T09:00:00Z', '2026-04-04T09:00:00Z'),
('cmp_1007', 'LM-VID-045', 'Pre-Roll Engagement Drive',         'Helix Pharma',       'Active',    'Video Views', 'Video',   '2026-03-28', '2026-05-05', 72000.00,  'Priya Sharma', 'EU',  '2026-03-28T09:00:00Z', '2026-04-04T09:00:00Z'),

-- Mixed / ambiguous campaigns
('cmp_1008', 'LM-DIS-052', 'Mid-Funnel Consideration Test',     'Bolt Electronics',   'Active',    'Traffic',     'Display', '2026-03-22', '2026-04-28', 55000.00,  'Marcus Webb',  'UK',  '2026-03-22T09:00:00Z', '2026-04-04T09:00:00Z'),
('cmp_1009', 'LM-CTV-018', 'Regional CTV Awareness Pilot',      'FreshFields Grocery','Active',    'Awareness',   'CTV',     '2026-03-30', '2026-05-12', 40000.00,  'Riley Chen',   'US',  '2026-03-30T09:00:00Z', '2026-04-04T09:00:00Z'),

-- Completed campaign (status variety)
('cmp_1010', 'LM-DIS-003', 'Q1 Holiday Display Wrap-Up',        'Acme Retail',        'Completed', 'Conversion',  'Display', '2025-12-01', '2026-01-15', 78000.00,  'Sam Okafor',   'US',  '2025-12-01T09:00:00Z', '2026-01-16T09:00:00Z');


-- ---------------------------------------------------------------------------
-- 2. Campaign Health  (40 rows — 4 snapshots per campaign)
-- ---------------------------------------------------------------------------

INSERT INTO campaign_health (id, campaign_id, snapshot_at, impressions, clicks, ctr, viewability, completion_rate, spend_usd, budget_pacing_pct, delivery_rate_pct, anomaly_flag, anomaly_reason, delivery_note) VALUES

-- cmp_1001  Spring Streaming Awareness  (HEALTHY)
('hlth_2001', 'cmp_1001', '2026-04-01T08:00:00Z', 310000,  1705, 0.550, 72.10, 83.00, 4600.00,  98.00, 99.00, false, NULL, 'Day 1 delivery on track'),
('hlth_2002', 'cmp_1001', '2026-04-02T08:00:00Z', 640000,  3520, 0.550, 71.80, 82.50, 9300.00,  97.50, 98.50, false, NULL, 'Pacing steady, engagement stable'),
('hlth_2003', 'cmp_1001', '2026-04-03T08:00:00Z', 960000,  5280, 0.550, 71.50, 82.80, 13900.00, 97.00, 98.00, false, NULL, 'All signals nominal'),
('hlth_2004', 'cmp_1001', '2026-04-04T08:00:00Z', 1250000, 6900, 0.552, 71.20, 82.40, 18400.00, 97.00, 98.50, false, NULL, 'Performance stable and pacing on target'),

-- cmp_1002  Brand Safety Display Push  (HEALTHY)
('hlth_2005', 'cmp_1002', '2026-04-01T08:00:00Z', 420000,  2940, 0.700, 68.50, NULL,  5200.00,  100.00, 101.00, false, NULL, 'Display delivery ahead of schedule'),
('hlth_2006', 'cmp_1002', '2026-04-02T08:00:00Z', 870000,  6090, 0.700, 69.10, NULL,  10500.00, 100.50, 101.50, false, NULL, 'CTR holding above benchmark'),
('hlth_2007', 'cmp_1002', '2026-04-03T08:00:00Z', 1310000, 9170, 0.700, 68.80, NULL,  15700.00, 100.00, 100.50, false, NULL, 'Healthy delivery pattern'),
('hlth_2008', 'cmp_1002', '2026-04-04T08:00:00Z', 1780000, 12460,0.700, 69.00, NULL,  21000.00, 100.00, 100.00, false, NULL, 'On pace, strong viewability'),

-- cmp_1003  Summer Video Blitz  (HEALTHY)
('hlth_2009', 'cmp_1003', '2026-04-01T08:00:00Z', 280000,  1400, 0.500, 65.00, 78.00, 5700.00,  96.00, 95.00, false, NULL, 'Early ramp — slightly under pace, expected'),
('hlth_2010', 'cmp_1003', '2026-04-02T08:00:00Z', 590000,  2950, 0.500, 66.20, 79.50, 11600.00, 97.00, 97.00, false, NULL, 'Delivery ramping up as expected'),
('hlth_2011', 'cmp_1003', '2026-04-03T08:00:00Z', 910000,  4550, 0.500, 66.80, 80.10, 17400.00, 98.00, 98.00, false, NULL, 'Completion rate trending up'),
('hlth_2012', 'cmp_1003', '2026-04-04T08:00:00Z', 1240000, 6200, 0.500, 67.00, 80.50, 23200.00, 98.50, 98.50, false, NULL, 'Strong video performance across placements'),

-- cmp_1004  Q2 Product Launch Video  (UNHEALTHY — low CTR, rising spend)
('hlth_2013', 'cmp_1004', '2026-04-01T08:00:00Z', 250000,  750,  0.300, 52.00, 61.00, 5500.00,  105.00, 80.00, false, NULL, 'Initial delivery slightly hot'),
('hlth_2014', 'cmp_1004', '2026-04-02T08:00:00Z', 520000,  1200, 0.230, 48.50, 58.00, 12200.00, 112.00, 78.00, true,  'CTR declining while spend accelerates', 'Spend outpacing engagement — review needed'),
('hlth_2015', 'cmp_1004', '2026-04-03T08:00:00Z', 780000,  1560, 0.200, 45.20, 56.50, 18800.00, 116.00, 77.00, true,  'CTR below threshold, viewability dropping', 'Escalation candidate: weak engagement on current creative mix'),
('hlth_2016', 'cmp_1004', '2026-04-04T08:00:00Z', 980000,  1800, 0.184, 43.70, 59.20, 22100.00, 118.00, 76.00, true,  'CTR and viewability dropped while spend increased', 'Escalation candidate: weak engagement on current creative mix'),

-- cmp_1005  Retargeting Conversion Wave  (UNHEALTHY — poor viewability)
('hlth_2017', 'cmp_1005', '2026-04-01T08:00:00Z', 180000,  810,  0.450, 38.00, NULL,  3800.00,  95.00, 92.00, false, NULL, 'Viewability below target but early'),
('hlth_2018', 'cmp_1005', '2026-04-02T08:00:00Z', 370000,  1480, 0.400, 34.20, NULL,  7800.00,  97.00, 94.00, true,  'Viewability dropped below 40% threshold', 'Viewability declining — placement review recommended'),
('hlth_2019', 'cmp_1005', '2026-04-03T08:00:00Z', 560000,  2130, 0.380, 31.50, NULL,  11900.00, 99.00, 95.00, true,  'Viewability continues to decline', 'Below acceptable viewability floor for conversion objective'),
('hlth_2020', 'cmp_1005', '2026-04-04T08:00:00Z', 740000,  2740, 0.370, 29.80, NULL,  15800.00, 100.00, 96.00, true,  'Viewability critically low at 29.8%', 'Urgent: viewability well below client threshold'),

-- cmp_1006  Connected TV Reach Boost  (UNHEALTHY — underdelivery / pacing issues)
('hlth_2021', 'cmp_1006', '2026-04-01T08:00:00Z', 200000,  900,  0.450, 70.00, 81.00, 3200.00,  52.00, 58.00, true,  'Severe underdelivery from day 1', 'Delivery significantly below flight plan'),
('hlth_2022', 'cmp_1006', '2026-04-02T08:00:00Z', 380000,  1710, 0.450, 69.50, 80.50, 6100.00,  55.00, 60.00, true,  'Underdelivery persists despite adequate budget', 'Targeting may be too narrow for available CTV inventory'),
('hlth_2023', 'cmp_1006', '2026-04-03T08:00:00Z', 540000,  2430, 0.450, 69.80, 80.80, 8700.00,  53.00, 59.00, true,  'Pacing stuck around 55%', 'Inventory constraints suspected — consider broadening targeting'),
('hlth_2024', 'cmp_1006', '2026-04-04T08:00:00Z', 690000,  3100, 0.449, 70.10, 81.20, 11200.00, 54.00, 58.50, true,  'Underdelivery unchanged despite good engagement', 'Quality metrics fine — this is a supply/targeting issue'),

-- cmp_1007  Pre-Roll Engagement Drive  (UNHEALTHY — creative fatigue)
('hlth_2025', 'cmp_1007', '2026-04-01T08:00:00Z', 190000,  1140, 0.600, 62.00, 74.00, 4100.00,  100.00, 99.00, false, NULL, 'Strong initial engagement'),
('hlth_2026', 'cmp_1007', '2026-04-02T08:00:00Z', 400000,  2000, 0.500, 60.50, 70.00, 8400.00,  101.00, 98.00, false, NULL, 'Slight engagement dip — monitoring'),
('hlth_2027', 'cmp_1007', '2026-04-03T08:00:00Z', 620000,  2480, 0.400, 57.30, 64.50, 12800.00, 102.00, 97.00, true,  'CTR and completion rate declining day over day', 'Creative fatigue pattern — same assets running since launch'),
('hlth_2028', 'cmp_1007', '2026-04-04T08:00:00Z', 830000,  2820, 0.340, 54.10, 60.20, 17000.00, 103.00, 96.00, true,  'Engagement metrics in steady decline', 'Creative rotation recommended — fatigue confirmed'),

-- cmp_1008  Mid-Funnel Consideration Test  (MIXED — decent CTR, wobbling viewability)
('hlth_2029', 'cmp_1008', '2026-04-01T08:00:00Z', 220000,  1320, 0.600, 58.00, NULL,  4400.00,  99.00, 97.00, false, NULL, 'Solid CTR, viewability slightly below target'),
('hlth_2030', 'cmp_1008', '2026-04-02T08:00:00Z', 460000,  2760, 0.600, 54.50, NULL,  9000.00,  100.00, 98.00, false, NULL, 'CTR strong but viewability drifting down'),
('hlth_2031', 'cmp_1008', '2026-04-03T08:00:00Z', 700000,  4200, 0.600, 61.20, NULL,  13500.00, 99.50, 98.50, false, NULL, 'Viewability recovered — mixed signal day'),
('hlth_2032', 'cmp_1008', '2026-04-04T08:00:00Z', 950000,  5700, 0.600, 56.80, NULL,  18200.00, 100.50, 99.00, false, NULL, 'Good engagement but viewability inconsistent — diagnosis unclear'),

-- cmp_1009  Regional CTV Awareness Pilot  (MIXED — small scale, noisy data)
('hlth_2033', 'cmp_1009', '2026-04-01T08:00:00Z', 48000,   216,  0.450, 66.00, 77.00, 1200.00,  90.00, 85.00, false, NULL, 'Small-scale pilot — limited data'),
('hlth_2034', 'cmp_1009', '2026-04-02T08:00:00Z', 105000,  525,  0.500, 62.00, 79.00, 2600.00,  93.00, 88.00, false, NULL, 'Metrics volatile due to small sample'),
('hlth_2035', 'cmp_1009', '2026-04-03T08:00:00Z', 170000,  680,  0.400, 69.50, 75.00, 4100.00,  95.00, 90.00, false, NULL, 'CTR dropped but viewability jumped — sample noise likely'),
('hlth_2036', 'cmp_1009', '2026-04-04T08:00:00Z', 240000,  960,  0.400, 64.80, 76.50, 5500.00,  94.00, 89.00, false, NULL, 'Signals too noisy to diagnose confidently at current scale'),

-- cmp_1010  Q1 Holiday Display Wrap-Up  (COMPLETED — resolved, historical)
('hlth_2037', 'cmp_1010', '2025-12-15T08:00:00Z', 1400000, 8400, 0.600, 63.00, NULL,  28000.00, 95.00, 94.00, false, NULL, 'Mid-flight — on track'),
('hlth_2038', 'cmp_1010', '2026-01-01T08:00:00Z', 2800000, 15120,0.540, 60.50, NULL,  54000.00, 96.00, 95.00, false, NULL, 'Post-holiday dip in CTR, normal seasonal pattern'),
('hlth_2039', 'cmp_1010', '2026-01-10T08:00:00Z', 3600000, 18000,0.500, 59.00, NULL,  70000.00, 98.00, 97.00, false, NULL, 'Winding down — pacing on target for close'),
('hlth_2040', 'cmp_1010', '2026-01-15T08:00:00Z', 3950000, 19750,0.500, 58.50, NULL,  77500.00, 99.50, 99.00, false, NULL, 'Campaign complete — final delivery within tolerance');


-- ---------------------------------------------------------------------------
-- 3. Investigations  (5 rows)
-- ---------------------------------------------------------------------------
-- Status mix: 1 New, 1 Investigating, 1 Needs Action, 1 Resolved, 1 Investigating
-- Campaigns with NO investigation (available for live demo): cmp_1001, 1002, 1003, 1008, 1009
-- ---------------------------------------------------------------------------

INSERT INTO investigations (id, campaign_id, source_snapshot_id, issue_type, severity, status, owner_name, question, hypothesis, next_action, resolution_summary, opened_at, updated_at, resolved_at) VALUES

-- New — just opened, no work done yet
('inv_3001', 'cmp_1007', 'hlth_2028', 'Creative Fatigue', 'Medium', 'New',
 'Priya Sharma',
 'Why are CTR and completion rate declining steadily since launch despite on-target delivery?',
 'The same creative assets have been running since day one and audience frequency is driving fatigue.',
 'Pull creative-level performance breakdown and compare day 1 vs day 7 engagement.',
 NULL,
 '2026-04-04T10:30:00Z', '2026-04-04T10:30:00Z', NULL),

-- Investigating — actively being worked
('inv_3002', 'cmp_1004', 'hlth_2016', 'Low CTR', 'High', 'Investigating',
 'Riley Chen',
 'Why did CTR and viewability decline while spend increased over the last 72 hours?',
 'Creative fatigue and weak placement mix are reducing engagement quality.',
 'Review creative-level breakdown and compare top placements before changing pacing.',
 NULL,
 '2026-04-04T09:15:00Z', '2026-04-04T10:00:00Z', NULL),

-- Needs Action — diagnosis done, waiting on operator to act
('inv_3003', 'cmp_1005', 'hlth_2020', 'Low Viewability', 'Critical', 'Needs Action',
 'Sam Okafor',
 'Why has viewability dropped below 30% on a conversion-objective campaign?',
 'Low-quality placements dominating the delivery mix — likely open-exchange inventory with below-the-fold slots.',
 'Apply placement blocklist and shift budget to PMP deals with viewability guarantees.',
 NULL,
 '2026-04-03T14:00:00Z', '2026-04-04T08:30:00Z', NULL),

-- Investigating — underdelivery case
('inv_3004', 'cmp_1006', 'hlth_2024', 'Underdelivery', 'High', 'Investigating',
 'Jordan Lee',
 'Why is delivery stuck around 55% of flight plan despite full budget availability?',
 'CTV targeting criteria are too narrow for available regional inventory.',
 'Test a broader audience segment in a secondary ad group to measure inventory lift.',
 NULL,
 '2026-04-02T11:00:00Z', '2026-04-04T09:00:00Z', NULL),

-- Resolved — the completed campaign had an issue that was fixed
('inv_3005', 'cmp_1010', 'hlth_2038', 'Data Discrepancy', 'Low', 'Resolved',
 'Sam Okafor',
 'Why did the reporting dashboard show a 12% impression discrepancy compared to the ad server?',
 'Timezone mismatch between the dashboard aggregation window and the ad server log timestamps.',
 'Confirm fix by comparing next day''s report against ad-server totals.',
 'Root cause confirmed: dashboard was aggregating on UTC while ad server used EST. Timezone alignment applied; discrepancy resolved in subsequent reports.',
 '2026-01-02T10:00:00Z', '2026-01-05T16:00:00Z', '2026-01-05T16:00:00Z');


-- ---------------------------------------------------------------------------
-- 4. Investigation Evidence  (12 rows)
-- ---------------------------------------------------------------------------

INSERT INTO investigation_evidence (id, investigation_id, snapshot_id, evidence_type, title, summary, metric_name, metric_value, metric_unit, source_label, source_ref, captured_at, captured_by, is_key_evidence, sort_order) VALUES

-- Evidence for inv_3001 (Creative Fatigue — New)
('ev_4001', 'inv_3001', 'hlth_2028', 'Metric', 'CTR declining since launch',
 'CTR dropped from 0.60% on day 1 to 0.34% by day 7, a 43% decline.',
 'CTR', 0.3400, '%', 'Daily health snapshot', 'hlth_2028',
 '2026-04-04T10:35:00Z', 'system', true, 1),

('ev_4002', 'inv_3001', 'hlth_2028', 'Metric', 'Completion rate falling in parallel',
 'Video completion rate dropped from 74% to 60.2% over the same period.',
 'Completion Rate', 60.2000, '%', 'Daily health snapshot', 'hlth_2028',
 '2026-04-04T10:36:00Z', 'system', true, 2),

-- Evidence for inv_3002 (Low CTR — Investigating)
('ev_4003', 'inv_3002', 'hlth_2016', 'Metric', 'CTR dropped below expected range',
 'CTR fell to 0.18%, materially below the campaign average and category benchmark.',
 'CTR', 0.1840, '%', 'Daily health snapshot', 'hlth_2016',
 '2026-04-04T09:20:00Z', 'system', true, 1),

('ev_4004', 'inv_3002', 'hlth_2016', 'Delivery Note', 'Delivery note flagged escalation',
 'Escalation candidate: weak engagement on current creative mix.',
 NULL, NULL, NULL, 'Operator note', 'health-monitor',
 '2026-04-04T09:22:00Z', 'system', false, 2),

('ev_4005', 'inv_3002', NULL, 'Operator Note', 'Placement review requested',
 'Riley requested a placement-level breakdown to isolate which exchanges are dragging CTR down.',
 NULL, NULL, NULL, 'Investigation log', 'inv_3002',
 '2026-04-04T09:45:00Z', 'Riley Chen', false, 3),

-- Evidence for inv_3003 (Low Viewability — Needs Action)
('ev_4006', 'inv_3003', 'hlth_2020', 'Metric', 'Viewability at 29.8%',
 'Viewability has fallen to 29.8%, well below the 50% client threshold for conversion campaigns.',
 'Viewability', 29.8000, '%', 'Daily health snapshot', 'hlth_2020',
 '2026-04-04T08:35:00Z', 'system', true, 1),

('ev_4007', 'inv_3003', NULL, 'QA Check', 'Placement audit completed',
 'Audit found 62% of impressions served on open-exchange below-the-fold inventory with no viewability floor.',
 NULL, NULL, NULL, 'QA team', 'qa-audit-20260404',
 '2026-04-04T09:00:00Z', 'Sam Okafor', true, 2),

('ev_4008', 'inv_3003', NULL, 'Recommendation', 'Shift to PMP deals',
 'Recommend reallocating 70% of remaining budget to PMP deals with 60%+ viewability guarantees.',
 NULL, NULL, NULL, 'AI recommendation', 'air_5002',
 '2026-04-04T09:10:00Z', 'system', false, 3),

-- Evidence for inv_3004 (Underdelivery — Investigating)
('ev_4009', 'inv_3004', 'hlth_2024', 'Metric', 'Pacing stuck at 54%',
 'Budget pacing has plateaued around 54% despite full budget availability and no bid caps.',
 'Budget Pacing', 54.0000, '%', 'Daily health snapshot', 'hlth_2024',
 '2026-04-04T09:05:00Z', 'system', true, 1),

('ev_4010', 'inv_3004', NULL, 'Operator Note', 'Targeting hypothesis logged',
 'Jordan suspects the geo + demo + CTV device targeting combination is too restrictive for available supply.',
 NULL, NULL, NULL, 'Investigation log', 'inv_3004',
 '2026-04-03T15:00:00Z', 'Jordan Lee', false, 2),

-- Evidence for inv_3005 (Data Discrepancy — Resolved)
('ev_4011', 'inv_3005', 'hlth_2038', 'Metric', 'Impression discrepancy of 12%',
 'Dashboard reported 2.49M impressions vs ad server 2.80M — a 12% gap.',
 'Impression Delta', 12.0000, '%', 'Reconciliation report', 'recon-20260102',
 '2026-01-02T10:30:00Z', 'system', true, 1),

('ev_4012', 'inv_3005', NULL, 'QA Check', 'Timezone root cause confirmed',
 'QA confirmed dashboard was aggregating on UTC midnight while ad server logs used EST midnight, causing a window mismatch.',
 NULL, NULL, NULL, 'QA team', 'qa-tz-check',
 '2026-01-04T14:00:00Z', 'Sam Okafor', true, 2);


-- ---------------------------------------------------------------------------
-- 5. AI Runs  (3 rows)
-- ---------------------------------------------------------------------------

INSERT INTO ai_runs (id, investigation_id, model, task_type, input_tokens, output_tokens, estimated_cost_usd, latency_ms, prompt_summary, recommendation_summary, created_at) VALUES

('air_5001', 'inv_3002', 'sonnet', 'recommendation', 4200, 620, 0.0300, 2800,
 'Summarize likely causes of declining CTR and propose next step.',
 'Review creative fatigue indicators and isolate underperforming placement segments before adjusting pacing.',
 '2026-04-04T09:30:00Z'),

('air_5002', 'inv_3003', 'haiku', 'triage', 1800, 340, 0.0040, 950,
 'Classify viewability issue severity and recommend immediate action.',
 'Recommend reallocating 70% of remaining budget to PMP deals with 60%+ viewability guarantees. Severity: Critical.',
 '2026-04-04T09:08:00Z'),

('air_5003', 'inv_3004', 'sonnet', 'summary', 3100, 480, 0.0210, 2200,
 'Summarize underdelivery pattern and suggest targeting adjustments.',
 'Delivery constrained by narrow CTV targeting overlap. Suggest testing broader age range in a secondary ad group while maintaining primary audience in the main line item.',
 '2026-04-04T09:10:00Z');
