import { createConsumer } from "@rails/actioncable";
console.log("consumer.js: Loaded at", new Date().toISOString());

const host = window.location.host;
let cableUrl;
if (host.includes("docsync-8ti1.onrender.com")) {
  cableUrl = "wss://docsync-8ti1.onrender.com/cable";
} else if (host.includes("0.0.0.0:4000")) {
  cableUrl = "ws://0.0.0.0:4000/cable";
} else {
  cableUrl = "ws://localhost:3000/cable";
}

console.log("consumer.js: Connecting to", cableUrl);
export default createConsumer(cableUrl);