// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyD5e6-JVj_32O8QG8URscBV5epeQ9Z8pGU",
  authDomain: "kindmeals-fba5e.firebaseapp.com",
  projectId: "kindmeals-fba5e",
  storageBucket: "kindmeals-fba5e.firebasestorage.app",
  messagingSenderId: "890474310680",
  appId: "1:890474310680:web:9a3748bf314ffdcb76276d",
  measurementId: "G-DXRFNJ1MQ0"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

export {auth};