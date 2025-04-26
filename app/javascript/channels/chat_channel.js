import consumer from "./consumer";

console.log("chat_channel.js: Script started loading at", new Date().toISOString());

let subscription = null;

document.addEventListener("turbo:load", () => {
  console.log("turbo:load fired at", new Date().toISOString());
  window.subscribeToChatChannel = function() {
    try {
      console.log("subscribeToChatChannel called at", new Date().toISOString());
      if (subscription) {
        console.log("Already subscribed to ChatChannel, skipping...");
        return;
      }

      const conversationMeta = document.querySelector('meta[name="conversation-id"]');
      if (conversationMeta) {
        console.log("Found conversation meta tag");
        const conversationId = conversationMeta.content;
        const messagesContainer = document.getElementById("messages");
        const currentUserEmail = messagesContainer ? messagesContainer.dataset.currentUserEmail : null;
        const currentUserFullName = messagesContainer ? messagesContainer.dataset.currentUserFullName : null;

        console.log("Conversation ID:", conversationId);
        console.log("Messages Container:", messagesContainer);
        console.log("Current User Email:", currentUserEmail);
        console.log("Current User Full Name:", currentUserFullName);

        if (conversationId && currentUserEmail && currentUserFullName) {
          console.log("Attempting to subscribe to ChatChannel with params:", { channel: "ChatChannel", conversation_id: conversationId });
          subscription = consumer.subscriptions.create(
            { channel: "ChatChannel", conversation_id: conversationId },
            {
              connected() {
                console.log(`Connected to ChatChannel for conversation ${conversationId}`);
              },
              disconnected() {
                console.log("Disconnected from ChatChannel");
                subscription = null;
              },
              received(data) {
                console.log("Received data:", data);
                const messages = document.getElementById("messages");
                const messageDiv = document.createElement("div");
                messageDiv.id = `message-${data.id}`;
                messageDiv.className = `mb-2 ${data.user === currentUserEmail ? "text-end" : "text-start"}`;
                const userName = data.user === currentUserEmail ? currentUserFullName : data.user_name;
                messageDiv.innerHTML = `<strong>${userName || 'Unknown User'}:</strong> ${data.content} <small class="text-muted">(${data.created_at})</small>`;
                messages.appendChild(messageDiv);
                messages.scrollTop = messages.scrollHeight;
              },
              rejected() {
                console.log("Subscription rejected for conversation", conversationId);
              }
            }
          );
        } else {
          console.error("Missing conversationId, currentUserEmail, or currentUserFullName");
        }
      } else {
        console.error("No conversation meta tag found");
        console.log("All meta tags:", document.querySelectorAll('meta'));
      }
    } catch (error) {
      console.error("Error in subscribeToChatChannel:", error);
    }
  };

  window.subscribeToChatChannel();
});

console.log("chat_channel.js: Script finished loading at", new Date().toISOString());