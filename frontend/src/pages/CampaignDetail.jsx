import { useParams, Link } from 'react-router-dom';

export default function CampaignDetail() {
  const { id } = useParams();

  return (
    <div>
      <Link to="/" className="text-sm text-muted-foreground hover:text-foreground">
        &larr; Back to campaigns
      </Link>

      <h2 className="mt-4 text-2xl font-semibold">Campaign Detail</h2>

      <div className="mt-4 rounded-lg border p-6">
        <p className="text-sm text-muted-foreground">Campaign ID: {id}</p>
        <p className="mt-2 text-sm text-muted-foreground">
          Detail view and investigation workflow will be built during the workshop.
        </p>
      </div>
    </div>
  );
}
