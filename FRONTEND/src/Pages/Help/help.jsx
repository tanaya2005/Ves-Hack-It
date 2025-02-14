import React, { useState } from "react";
import "./help.css";

const faqs = [
  { 
    question: "How do I update my profile information?", 
    answer: "Go to your Profile page, click 'Edit Profile,' update your details, and save changes."
  },
  { 
    question: "How can I reset my password?", 
    answer: "Click on 'Forgot Password' on the login page, enter your email, and follow the instructions." 
  },
  { 
    question: "How do I donate food?", 
    answer: "Navigate to the 'Donate' section, fill in the necessary details, and submit your donation request." 
  },
  { 
    question: "How can I track my past donations?", 
    answer: "Check the 'My Donations' section in your profile to view your donation history." 
  },
  { 
    question: "What should I do if I face an issue?", 
    answer: "Visit the 'Contact Support' section below and reach out for assistance." 
  }
];

const Help = () => {
  const [openIndex, setOpenIndex] = useState(null);

  const toggleFAQ = (index) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <div className="help-container">
      <h2>Help & Support</h2>
      <p>Find answers to common questions or reach out for help.</p>

      {/* FAQ Section */}
      <div className="faq-section">
        {faqs.map((faq, index) => (
          <div key={index} className="faq-item">
            <div className="faq-question" onClick={() => toggleFAQ(index)}>
              {faq.question}
              <span className={`faq-icon ${openIndex === index ? "open" : ""}`}>▼</span>
            </div>
            {openIndex === index && <div className="faq-answer">{faq.answer}</div>}
          </div>
        ))}
      </div>

      {/* Contact Support Section */}
      <div className="contact-support">
        <h3>Contact Support</h3>
        <p>If you need further assistance, visit our <a href="/enquire" className="contact-link">Contact Us</a> page.</p>
      </div>

      {/* Feedback Section */}
      <div className="feedback-section">
        <h3>Give Us Your Feedback</h3>
        <p>We value your opinion! Let us know how we can improve.</p>
        <form className="feedback-form">
          <textarea placeholder="Write your feedback here..." required></textarea>
          <button type="submit">Submit Feedback</button>
        </form>
      </div>
    </div>
  );
};

export default Help;
