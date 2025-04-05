import React, { useState, useEffect, useCallback } from 'react';
import RewardItem from './RewardItem';

const RewardsList = ({ userId, onRedemption }) => {
  const [rewards, setRewards] = useState([]);
  const [userPoints, setUserPoints] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch rewards and initial user points
  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch rewards
        const rewardsResponse = await fetch('/api/v1/rewards');
        if (!rewardsResponse.ok) {
          throw new Error('Failed to fetch rewards');
        }
        const rewardsData = await rewardsResponse.json();
        setRewards(rewardsData);

        // Fetch user points
        const pointsResponse = await fetch(`/api/v1/users/${userId}/points`);
        if (!pointsResponse.ok) {
          throw new Error('Failed to fetch user points');
        }
        const pointsData = await pointsResponse.json();
        setUserPoints(pointsData.points);

        setLoading(false);
      } catch (err) {
        setError(err.message);
        setLoading(false);
      }
    };

    fetchData();
  }, [userId]);

  // Function to fetch updated points
  const fetchUserPoints = useCallback(async () => {
    if (loading) return;

    try {
      const response = await fetch(`/api/v1/users/${userId}/points`);
      if (response.ok) {
        const data = await response.json();
        setUserPoints(data.points);
      }
    } catch (error) {
      console.error('Failed to update points:', error);
    }
  }, [userId, loading]);

  // Update points when onRedemption changes
  useEffect(() => {
    fetchUserPoints();
  }, [fetchUserPoints, onRedemption]);

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
            userPoints={userPoints}
            onRedemption={() => {
              fetchUserPoints();
              if (onRedemption) onRedemption();
            }}
          />
        ))}
      </div>
    </div>
  );
};

export default RewardsList;
