import "@hotwired/turbo-rails";
import "controllers";
import "./channels/consumer";
import "./channels/chat_channel";
import "./channels/notifications_channel";

console.log("application.js: Script loaded at", new Date().toISOString());