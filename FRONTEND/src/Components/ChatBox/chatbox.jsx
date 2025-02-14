// src/components/ChatBox.jsx
import React, { useState } from 'react';
import './chatbox.css';
import { assets } from '../../assets/assets';

const ChatBox = () => {
  return (
    <div className='chatbox'>
        <img src={assets.chat} alt="chat here" />
    </div>
  );
};

export default ChatBox;
