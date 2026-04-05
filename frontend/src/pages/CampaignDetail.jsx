import { useParams } from 'react-router-dom';

export default function CampaignDetail() {
  const { id } = useParams();

  return (
    <div>
      <h2 className="page-title">Campaign Detail</h2>

      <div className="campaign-card">
        <p>
          <strong>Campaign ID:</strong> {id}
        </p>
        <p style={{ marginTop: '1rem', marginBottom: 0 }}>
          Campaign detail and investigation workflow will be built during the workshop.
        </p>
      </div>
    </div>
  );
}
