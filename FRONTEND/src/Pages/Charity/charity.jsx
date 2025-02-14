import React, { useState } from 'react';
import './charity.css';

const Charity = () => {
  const [amount, setAmount] = useState('');
  const [paymentMethod, setPaymentMethod] = useState('upi');

  const handleAmountClick = (value) => {
    setAmount(value);
  };

  const handleAmountChange = (e) => {
    const value = e.target.value;
    // Ensure only positive values and remove leading zeros
    if (value === '' || (Number(value) > 0 && Number.isInteger(Number(value)))) {
      setAmount(value);
    }
  };

  const handleDonate = () => {
    if (!amount || Number(amount) <= 0) {
      alert('Please enter a valid donation amount (₹1 or more).');
      return;
    }
    alert(`Thank you for donating ₹${amount} via ${paymentMethod.toUpperCase()}! ❤️`);
  };

  return (
    <div className="charity">
      <div className="charity-container">
        <h1>Help the Needy, Donate Today ❤️</h1>
        <p>Your small contribution can make a big difference in someone's life.</p>

        {/* Donation Amount Selection */}
        <div className="donation-amounts">
          <button onClick={() => handleAmountClick(100)}>₹100</button>
          <button onClick={() => handleAmountClick(500)}>₹500</button>
          <button onClick={() => handleAmountClick(1000)}>₹1000</button>
        </div>

        {/* Custom Amount Input */}
        <input 
          type="number" 
          className="custom-amount" 
          placeholder="Enter Custom Amount (₹)" 
          value={amount} 
          onChange={handleAmountChange} 
          min="1"
        />

        {/* Impact Section */}
        <div className="impact-section">
          <h2>How Your Donation Helps:</h2>
          <p>💖 ₹100 - Provides a meal for a family in need.</p>
          <p>📚 ₹500 - Supports education for an underprivileged child.</p>
          <p>🏥 ₹1000 - Helps fund medical assistance for the needy.</p>
        </div>

        {/* Payment Method Selection */}
        <div className="payment-method">
          <label>
            <input 
              type="radio" 
              value="upi" 
              checked={paymentMethod === 'upi'} 
              onChange={() => setPaymentMethod('upi')} 
            />
            UPI
          </label>
          <label>
            <input 
              type="radio" 
              value="credit-debit" 
              checked={paymentMethod === 'credit-debit'} 
              onChange={() => setPaymentMethod('credit-debit')} 
            />
            Credit/Debit Card
          </label>
        </div>

        {/* Donate Button */}
        <button className="donate-btn" onClick={handleDonate}>Donate Now</button>
      </div>
    </div>
  );
};

export default Charity;
