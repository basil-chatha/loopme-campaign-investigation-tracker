import { Routes, Route, Link } from 'react-router-dom';
import CampaignList from './pages/CampaignList';
import CampaignDetail from './pages/CampaignDetail';
import './App.css';

export default function App() {
  return (
    <div className="app-layout">
      <header className="app-header">
        <div className="header-content">
          <h1>Campaign Investigation Tracker</h1>
          <nav className="header-nav">
            <Link to="/">Campaigns</Link>
          </nav>
        </div>
      </header>

      <main className="app-main">
        <Routes>
          <Route path="/" element={<CampaignList />} />
          <Route path="/campaigns/:id" element={<CampaignDetail />} />
        </Routes>
      </main>
    </div>
  );
}
