import "@hotwired/turbo-rails";
import "controllers";
import "channels";

console.log("application.js: Script loaded at", new Date().toISOString());

// No es necesario llamar a subscribeToChatChannel aquí, ya se llama en chat_channel.js;
