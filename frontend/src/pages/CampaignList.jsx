import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { getCampaigns } from '../api/client';

export default function CampaignList() {
  const [campaigns, setCampaigns] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const data = await getCampaigns();
        setCampaigns(data);
        setError(null);
      } catch (err) {
        setError(err.message || 'Failed to fetch campaigns');
        setCampaigns([]);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return <div className="loading">Loading campaigns...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  return (
    <div>
      <h2 className="page-title">Campaigns</h2>

      {campaigns.length === 0 ? (
        <div className="loading">No campaigns found.</div>
      ) : (
        <div className="campaign-list">
          <table className="campaign-table">
            <thead>
              <tr>
                <th>Campaign Code</th>
                <th>Name</th>
                <th>Advertiser</th>
                <th>Status</th>
                <th>Objective</th>
                <th>Channel</th>
                <th>Budget (USD)</th>
              </tr>
            </thead>
            <tbody>
              {campaigns.map((campaign) => (
                <tr key={campaign.id}>
                  <td>
                    <Link to={`/campaigns/${campaign.id}`} className="campaign-row-link">
                      {campaign.campaign_code}
                    </Link>
                  </td>
                  <td>{campaign.name}</td>
                  <td>{campaign.advertiser}</td>
                  <td>
                    <span
                      className={`status-badge ${campaign.status.toLowerCase()}`}
                    >
                      {campaign.status}
                    </span>
                  </td>
                  <td>{campaign.objective}</td>
                  <td>{campaign.channel}</td>
                  <td>${campaign.budget_usd?.toLocaleString() || '0'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
