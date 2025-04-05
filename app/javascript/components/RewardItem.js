import React, { useState } from 'react';

const RewardItem = ({ reward, userId, onRedemption }) => {
  const [redeeming, setRedeeming] = useState(false);
  const [message, setMessage] = useState(null);
  const [messageType, setMessageType] = useState(null);

  const handleRedeem = async () => {
    setRedeeming(true);
    setMessage(null);

    try {
      const response = await fetch(`/api/v1/users/${userId}/redemptions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ reward_id: reward.id })
      });

      const data = await response.json();

      if (response.ok) {
        setMessageType('success');
        setMessage('Reward redeemed successfully!');
        if (onRedemption) {
          onRedemption(data.remaining_points);
        }
      } else {
        setMessageType('error');
        setMessage(data.error || 'Failed to redeem reward');
      }
    } catch (err) {
      setMessageType('error');
      setMessage('Network error. Please try again.');
    } finally {
      setRedeeming(false);
    }
  };

  return (
    <div className="reward-item">
      <h3>{reward.name}</h3>
      <p className="description">{reward.description}</p>
      <p className="points-required">{reward.points_required} points</p>

      {message && (
        <div className={`message ${messageType}`}>{message}</div>
      )}

      <button
        onClick={handleRedeem}
        disabled={redeeming}
        className="redeem-button"
        type="button"
      >
        {redeeming ? 'Redeeming...' : 'Redeem'}
      </button>
    </div>
  );
};

export default RewardItem;
