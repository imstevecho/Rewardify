import React, { useEffect } from 'react';

const Modal = ({ isOpen, title, message, onConfirm, onCancel }) => {
  // Prevent scrolling when modal is open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'auto';
    }

    return () => {
      document.body.style.overflow = 'auto';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div className="modal-overlay">
      <div className="modal-container">
        <div className="modal-header">
          <h2>{title}</h2>
        </div>
        <div className="modal-body">
          <p>{message}</p>
        </div>
        <div className="modal-footer">
          {onCancel && (
            <button
              type="button"
              className="modal-button cancel-button"
              onClick={onCancel}
            >
              Cancel
            </button>
          )}
          <button
            type="button"
            className="modal-button confirm-button"
            onClick={onConfirm}
          >
            OK
          </button>
        </div>
      </div>
    </div>
  );
};

export default Modal;
