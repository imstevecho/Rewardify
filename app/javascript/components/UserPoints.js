import React, { useState, useEffect } from 'react';

const UserPoints = ({ userId }) => {
  const [points, setPoints] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchPoints = async () => {
      try {
        const response = await fetch(`/api/v1/users/${userId}/points`);
        if (!response.ok) {
          throw new Error('Failed to fetch points');
        }
        const data = await response.json();
        setPoints(data.points);
        setLoading(false);
      } catch (err) {
        setError(err.message);
        setLoading(false);
      }
    };

    fetchPoints();
  }, [userId]);

  if (loading) {
    return <div className="loading">Loading points...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  return (
    <div className="user-points">
      <h2>Your Point Balance</h2>
      <div className="points-value">{points} points</div>
    </div>
  );
};

export default UserPoints;
