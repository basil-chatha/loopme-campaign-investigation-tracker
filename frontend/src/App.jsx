import { Routes, Route, Link } from 'react-router-dom';
import CampaignList from './pages/CampaignList';
import CampaignDetail from './pages/CampaignDetail';
import InvestigationDetail from './pages/InvestigationDetail';

export default function App() {
  return (
    <div className="min-h-screen bg-background">
      <header className="border-b bg-primary text-primary-foreground">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
          <h1 className="text-xl font-semibold">Campaign Investigation Tracker</h1>
          <nav>
            <Link to="/" className="text-sm text-primary-foreground/80 hover:text-primary-foreground">
              Campaigns
            </Link>
          </nav>
        </div>
      </header>

      <main className="mx-auto max-w-6xl px-6 py-8">
        <Routes>
          <Route path="/" element={<CampaignList />} />
          <Route path="/campaigns/:id" element={<CampaignDetail />} />
          <Route path="/investigations/:id" element={<InvestigationDetail />} />
        </Routes>
      </main>
    </div>
  );
}
