import React, { useEffect } from 'react';
import { createPortal } from 'react-dom';

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

  // Create portal to render modal at the document body level
  return createPortal(
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
    </div>,
    document.body
  );
};

export default Modal;
