import { createConsumer } from "@rails/actioncable";
console.log("consumer.js: Loaded at", new Date().toISOString());

const cableUrl = process.env.NODE_ENV === "production" 
  ? "wss://docsync-8ti1.onrender.com/cable" 
  : window.location.protocol === "https:" 
    ? `wss://${window.location.host}/cable` 
    : `ws://${window.location.host}/cable`;

export default createConsumer(cableUrl);