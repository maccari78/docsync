import { createConsumer } from "@rails/actioncable";
console.log("consumer.js: Loaded at", new Date().toISOString());

const cableUrl = document.querySelector('meta[name="action-cable-url"]')?.content || "ws://localhost:3000/cable";
export default createConsumer(cableUrl);