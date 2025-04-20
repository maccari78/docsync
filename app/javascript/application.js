import "@hotwired/turbo-rails";
import "controllers";
import Rails from "@rails/ujs";
import "channels";

Rails.start();

console.log("application.js: Script loaded at", new Date().toISOString());

document.addEventListener("DOMContentLoaded", () => {
  console.log("application.js: Forcing subscribeToChatChannel on DOMContentLoaded");
  if (typeof subscribeToChatChannel === "function") {
    subscribeToChatChannel();
  } else {
    console.error("subscribeToChatChannel is not defined");
  }
});

console.log("application.js: Executing subscribeToChatChannel immediately");
if (typeof subscribeToChatChannel === "function") {
  subscribeToChatChannel();
} else {
  console.error("subscribeToChatChannel is not defined");
}