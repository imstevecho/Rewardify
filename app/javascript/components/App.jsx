import React, { useState } from 'react';
import UserPoints from './UserPoints';
import RewardsList from './RewardsList';
import RedemptionHistory from './RedemptionHistory';

const App = () => {
  // Hardcoded user ID for the test user - in a real app, this would come from authentication
  const [userId] = useState(1);
  const [activeTab, setActiveTab] = useState('rewards');
  const [pointsUpdated, setPointsUpdated] = useState(0);

  const handleRedemption = () => {
    // Increment to trigger a re-fetch of the user's points
    setPointsUpdated(prev => prev + 1);
  };

  return (
    <div className="rewards-app">
      <header className="app-header">
        <h1>Rewardify</h1>
        <div className="user-points-container">
          <UserPoints userId={userId} key={`points-${pointsUpdated}`} />
        </div>
      </header>

      <nav className="app-nav">
        <ul>
          <li>
            <button
              onClick={() => setActiveTab('rewards')}
              className={activeTab === 'rewards' ? 'active' : ''}
              type="button"
            >
              Available Rewards
            </button>
          </li>
          <li>
            <button
              onClick={() => setActiveTab('history')}
              className={activeTab === 'history' ? 'active' : ''}
              type="button"
            >
              Redemption History
            </button>
          </li>
        </ul>
      </nav>

      <main className="app-content">
        {activeTab === 'rewards' && (
          <RewardsList
            userId={userId}
            onRedemption={handleRedemption}
          />
        )}
        {activeTab === 'history' && (
          <RedemptionHistory userId={userId} />
        )}
      </main>

      <footer className="app-footer">
        <p>&copy; 2025 Rewardify - All rights reserved</p>
      </footer>
    </div>
  );
};

export default App;
