import { Badge } from '@/components/ui/badge';

export function fmtDate(iso) {
  if (!iso) return '-';
  return new Date(iso).toLocaleDateString();
}

export function Field({ label, value }) {
  return (
    <div>
      <span className="font-medium text-muted-foreground">{label}</span>
      <span className="mt-0.5 block">{value || '-'}</span>
    </div>
  );
}

const DEFAULT_BADGE_STYLE = 'bg-gray-100 text-gray-600';

export function StyledBadge({ value, styles }) {
  return (
    <Badge className={`font-medium ${styles[value] || DEFAULT_BADGE_STYLE}`}>
      {value}
    </Badge>
  );
}

export const NEXT_STATUS = {
  'New': 'Investigating',
  'Investigating': 'Needs Action',
  'Needs Action': 'Resolved',
};

export const INVESTIGATION_STATUS_STYLES = {
  New: 'bg-blue-50 text-blue-700',
  Investigating: 'bg-amber-50 text-amber-700',
  'Needs Action': 'bg-red-50 text-red-700',
  Resolved: 'bg-green-50 text-green-700',
};

export const SEVERITY_STYLES = {
  Critical: 'bg-red-100 text-red-800',
  High: 'bg-orange-50 text-orange-700',
  Medium: 'bg-amber-50 text-amber-700',
  Low: 'bg-gray-100 text-gray-600',
};
