import React from "react";
import "./enquire.css";

const contacts = [
  { name: "Varun Rahatgaonkar", position: "Customer Support", phone: "9372148550", email: "varun.support@example.com" },
  { name: "Tanaya Jain", position: "Technical Assistance", phone: "9594622999", email: "tanaya.tech@example.com" },
  { name: "Atharva Pingale", position: "Donation Coordinator", phone: "8329635392", email: "atharva.donations@example.com" },
  { name: "Nick Kale", position: "Volunteer Support", phone: "7700935000", email: "nick.volunteer@example.com" },
];

const Enquire = () => {
  return (
    <div className="enquire-container">
      <h2>Need Help? Contact Us</h2>
      <p>If you have any questions, feel free to reach out to our team.</p>

      <div className="contact-list">
        {contacts.map((contact, index) => (
          <div key={index} className="contact-card">
            <h3>{contact.name}</h3>
            <p><strong>Position:</strong> {contact.position}</p>
            <p><strong>Phone:</strong> <a href={`tel:${contact.phone}`} className="contact-link">{contact.phone}</a></p>
            <p><strong>Email:</strong> <a href={`mailto:${contact.email}`} className="contact-link">{contact.email}</a></p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Enquire;
