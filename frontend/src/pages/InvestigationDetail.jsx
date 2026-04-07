import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { getInvestigation, getAiRuns, updateInvestigationStatus } from '../api/client';
import { Field, fmtDate, StyledBadge, NEXT_STATUS, INVESTIGATION_STATUS_STYLES, SEVERITY_STYLES } from '../lib/investigation.jsx';

export default function InvestigationDetail() {
  const { id } = useParams();
  const [investigation, setInvestigation] = useState(null);
  const [aiRuns, setAiRuns] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [updatingStatus, setUpdatingStatus] = useState(false);

  useEffect(() => {
    let stale = false;
    setLoading(true);
    Promise.all([getInvestigation(id), getAiRuns(id)])
      .then(([invData, runsData]) => {
        if (!stale) {
          setInvestigation(invData);
          setAiRuns(runsData);
          setError(null);
        }
      })
      .catch((err) => {
        if (!stale) {
          setError(err.message);
          setInvestigation(null);
          setAiRuns([]);
        }
      })
      .finally(() => { if (!stale) setLoading(false); });
    return () => { stale = true; };
  }, [id]);

  const handleStatusChange = async (nextStatus) => {
    let resolutionSummary = null;
    if (nextStatus === 'Resolved') {
      resolutionSummary = prompt('Enter resolution summary:');
      if (!resolutionSummary) return;
    }
    setUpdatingStatus(true);
    try {
      const updated = await updateInvestigationStatus(id, nextStatus, resolutionSummary);
      setInvestigation(updated);
    } catch (err) {
      alert(`Failed to update status: ${err.message}`);
    } finally {
      setUpdatingStatus(false);
    }
  };

  if (loading) return <p className="text-muted-foreground">Loading investigation...</p>;
  if (error) return <p className="text-destructive">Error: {error}</p>;
  if (!investigation) return <p className="text-muted-foreground">Investigation not found.</p>;

  const nextStatus = NEXT_STATUS[investigation.status];

  return (
    <div>
      <Link
        to={`/campaigns/${investigation.campaign_id}`}
        className="text-sm text-muted-foreground hover:text-foreground"
      >
        &larr; Back to campaign
      </Link>

      <div className="mt-4 flex items-start justify-between">
        <div>
          <div className="flex items-center gap-2 mb-2">
            <StyledBadge value={investigation.status} styles={INVESTIGATION_STATUS_STYLES} />
            <StyledBadge value={investigation.severity} styles={SEVERITY_STYLES} />
            <span className="text-xs text-muted-foreground">{investigation.issue_type}</span>
          </div>
          <h2 className="text-2xl font-semibold">{investigation.question}</h2>
        </div>
        {nextStatus && (
          <button
            className="inline-flex items-center gap-1 rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-50"
            onClick={() => handleStatusChange(nextStatus)}
            disabled={updatingStatus}
          >
            {updatingStatus ? 'Updating...' : <>Mark as {nextStatus} &rarr;</>}
          </button>
        )}
      </div>

      <div className="mt-6 rounded-lg border p-6">
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
          <div>
            <h4 className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">Hypothesis</h4>
            <p className="mt-1 text-sm">{investigation.hypothesis || '-'}</p>
          </div>
          <div>
            <h4 className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">Next Action</h4>
            <p className="mt-1 text-sm">{investigation.next_action || '-'}</p>
          </div>
        </div>
        <div className="mt-6 grid grid-cols-2 gap-x-8 gap-y-3 text-sm md:grid-cols-4">
          <Field label="Owner" value={investigation.owner_name} />
          <Field label="Opened" value={fmtDate(investigation.opened_at)} />
          <Field label="Updated" value={fmtDate(investigation.updated_at)} />
          <Field label="Resolved" value={fmtDate(investigation.resolved_at)} />
        </div>
        {investigation.status === 'Resolved' && investigation.resolution_summary && (
          <div className="mt-6 rounded-md bg-green-50 border border-green-200 p-4">
            <h4 className="text-xs font-semibold uppercase tracking-wide text-green-800">Resolution</h4>
            <p className="mt-1 text-sm text-green-900">{investigation.resolution_summary}</p>
          </div>
        )}
      </div>

      <h3 className="mt-8 mb-4 text-lg font-semibold">
        AI Usage{' '}
        {aiRuns.length > 0 && (
          <span className="text-sm font-normal text-muted-foreground">({aiRuns.length})</span>
        )}
      </h3>

      {aiRuns.length === 0 ? (
        <div className="rounded-lg border border-dashed p-8 text-center">
          <p className="text-sm text-muted-foreground">No AI usage recorded for this investigation.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {aiRuns.map((run) => (
            <div key={run.id} className="rounded-lg border bg-slate-50 p-4">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-2">
                  <span className="inline-flex items-center rounded-md bg-slate-200 px-2 py-0.5 text-xs font-mono font-medium text-slate-700">
                    {run.model}
                  </span>
                  <span className="text-xs text-muted-foreground">{run.task_type}</span>
                </div>
                <span className="text-xs text-muted-foreground">{fmtDate(run.created_at)}</span>
              </div>
              <div className="grid grid-cols-3 gap-4 text-xs">
                <div>
                  <span className="text-muted-foreground">Tokens</span>
                  <span className="ml-1 font-mono tabular-nums">
                    {run.input_tokens?.toLocaleString() ?? '-'} in / {run.output_tokens?.toLocaleString() ?? '-'} out
                  </span>
                </div>
                <div>
                  <span className="text-muted-foreground">Cost</span>
                  <span className="ml-1 font-mono tabular-nums">
                    {run.estimated_cost_usd != null ? `$${run.estimated_cost_usd.toFixed(4)}` : '-'}
                  </span>
                </div>
                <div>
                  <span className="text-muted-foreground">Latency</span>
                  <span className="ml-1 font-mono tabular-nums">
                    {run.latency_ms != null ? `${run.latency_ms.toLocaleString()}ms` : '-'}
                  </span>
                </div>
              </div>
              {run.recommendation_summary && (
                <div className="mt-3 rounded-md bg-white border p-3">
                  <h5 className="text-xs font-semibold text-muted-foreground mb-1">Recommendation</h5>
                  <p className="text-sm">{run.recommendation_summary}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
