import { createConsumer } from "@rails/actioncable";
console.log("consumer.js: Loaded at", new Date().toISOString());
export default createConsumer("wss://localhost:3000/cable");
