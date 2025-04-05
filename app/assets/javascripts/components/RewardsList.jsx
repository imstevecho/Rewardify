import React, { useState, useEffect } from 'react';
import RewardItem from './RewardItem';

const RewardsList = ({ userId, onRedemption }) => {
  const [rewards, setRewards] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchRewards = async () => {
      try {
        const response = await fetch('/api/v1/rewards');
        if (!response.ok) {
          throw new Error('Failed to fetch rewards');
        }
        const data = await response.json();
        setRewards(data);
        setLoading(false);
      } catch (err) {
        setError(err.message);
        setLoading(false);
      }
    };

    fetchRewards();
  }, []);

  if (loading) {
    return <div className="loading">Loading rewards...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  if (rewards.length === 0) {
    return <div className="no-rewards">No rewards available at the moment.</div>;
  }

  return (
    <div className="rewards-list">
      <h2>Available Rewards</h2>
      <div className="rewards-grid">
        {rewards.map(reward => (
          <RewardItem
            key={reward.id}
            reward={reward}
            userId={userId}
            onRedemption={onRedemption}
          />
        ))}
      </div>
    </div>
  );
};

export default RewardsList;
