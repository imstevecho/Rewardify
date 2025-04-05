import React, { useState, useEffect } from 'react';

const RedemptionHistory = ({ userId }) => {
  const [redemptions, setRedemptions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchRedemptions = async () => {
      try {
        const response = await fetch(`/api/v1/users/${userId}/redemptions`);
        if (!response.ok) {
          throw new Error('Failed to fetch redemption history');
        }
        const data = await response.json();
        setRedemptions(data);
        setLoading(false);
      } catch (err) {
        setError(err.message);
        setLoading(false);
      }
    };

    fetchRedemptions();
  }, [userId]);

  if (loading) {
    return <div className="loading">Loading redemption history...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  if (redemptions.length === 0) {
    return <div className="no-redemptions">You haven't redeemed any rewards yet.</div>;
  }

  // Helper function to format date
  const formatDate = (dateString) => {
    const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
    return new Date(dateString).toLocaleDateString(undefined, options);
  };

  return (
    <div className="redemption-history">
      <h2>Redemption History</h2>
      <div className="redemption-list">
        {redemptions.map(redemption => (
          <div key={redemption.id} className="redemption-item">
            <h3>{redemption.reward.name}</h3>
            <p className="description">{redemption.reward.description}</p>
            <p className="points">
              <strong>Points spent:</strong> {redemption.reward.points_required}
            </p>
            <p className="redeemed-at">
              <strong>Redeemed:</strong> {formatDate(redemption.redeemed_at)}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default RedemptionHistory;
