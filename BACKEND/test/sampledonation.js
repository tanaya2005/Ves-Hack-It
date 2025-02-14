// sampledonations.js
const sampleDonations = [
    {
      foodName: "Fresh Vegetables Pack",
      organizationName: "Green Foods Market",
      quantity: "5 kg",
      description: "Fresh assorted vegetables including carrots, tomatoes, and lettuce",
      expiryDateTime: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000), // 2 days from now
      location: "123 Market Street, Mumbai",
      latitude: 19.0760,
      longitude: 72.8777,
      imageUrl: "vegetables.jpg", // You'll need this image in your uploads folder
      status: "available",
      donorId: "your-donor-id-here", // You'll need to replace this with a valid user ID
    },
    {
      foodName: "Bread and Pastries",
      organizationName: "City Bakery",
      quantity: "20 pieces",
      description: "Assorted fresh bread and pastries from today's baking",
      expiryDateTime: new Date(Date.now() + 24 * 60 * 60 * 1000), // 1 day from now
      location: "45 Bakery Lane, Mumbai",
      latitude: 19.0821,
      longitude: 72.8866,
      imageUrl: "bread.jpg",
      status: "available",
      donorId: "your-donor-id-here",
    },
    {
      foodName: "Rice and Dal Package",
      organizationName: "Food Relief NGO",
      quantity: "10 kg",
      description: "Basic food package containing 5kg rice and 5kg dal",
      expiryDateTime: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
      location: "78 Relief Center Road, Mumbai",
      latitude: 19.0898,
      longitude: 72.8856,
      imageUrl: "rice-dal.jpg",
      status: "available",
      donorId: "your-donor-id-here",
    }
  ];