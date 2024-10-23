// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDqfOFhLiU2wGNzuBQMjz3NbcIbdzEk_Io",
  authDomain: "studentdatabaseproject-5433d.firebaseapp.com",
  projectId: "studentdatabaseproject-5433d",
  storageBucket: "studentdatabaseproject-5433d.appspot.com",
  messagingSenderId: "516564451945",
  appId: "1:516564451945:web:b0875e86983bdbaabe18f8"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firestore
const db = getFirestore(app);

// Export Firestore instance
export { db };