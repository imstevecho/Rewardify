import React, { useState } from 'react';
import Modal from './Modal.jsx';

const RewardItem = ({ reward, userId, userPoints, onRedemption }) => {
  const [redeeming, setRedeeming] = useState(false);
  const [message, setMessage] = useState(null);
  const [messageType, setMessageType] = useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [showSuccessModal, setShowSuccessModal] = useState(false);

  // Check if user has enough points to redeem this reward
  const hasEnoughPoints = userPoints >= reward.points_required;

  const initiateRedeem = () => {
    setShowConfirmModal(true);
  };

  const handleConfirmRedeem = async () => {
    setShowConfirmModal(false);
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
        setShowSuccessModal(true);
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

  const handleCancelRedeem = () => {
    setShowConfirmModal(false);
  };

  const handleCloseSuccessModal = () => {
    setShowSuccessModal(false);
  };

  return (
    <div className="reward-item">
      <h3>{reward.name}</h3>
      <p className="description">{reward.description}</p>
      <p className="points-required">{reward.points_required} points</p>

      {message && messageType === 'error' && (
        <div className={`message ${messageType}`}>{message}</div>
      )}

      <button
        onClick={initiateRedeem}
        disabled={redeeming || !hasEnoughPoints}
        className="redeem-button"
        type="button"
      >
        {redeeming ? 'Redeeming...' : hasEnoughPoints ? 'Redeem' : 'Not enough points'}
      </button>

      {/* Confirmation Modal */}
      <Modal
        isOpen={showConfirmModal}
        title="Confirm Redemption"
        message={`Are you sure you want to redeem ${reward.name} for ${reward.points_required} points?`}
        onConfirm={handleConfirmRedeem}
        onCancel={handleCancelRedeem}
      />

      {/* Success Modal */}
      <Modal
        isOpen={showSuccessModal}
        title="Reward Redeemed"
        message="Reward redeemed successfully!"
        onConfirm={handleCloseSuccessModal}
      />
    </div>
  );
};

export default RewardItem;
