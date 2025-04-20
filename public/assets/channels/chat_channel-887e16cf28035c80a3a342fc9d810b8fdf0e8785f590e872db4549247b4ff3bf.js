import consumer from "./consumer";

console.log("chat_channel.js: Script started loading at", new Date().toISOString());

let subscription = null; // Almacena la suscripción para evitar duplicados

try {
  console.log("chat_channel.js loaded at", new Date().toISOString());
  console.log("Document readyState:", document.readyState);
  console.log("Turbo enabled:", document.body ? document.body.dataset.turbo : "body not yet loaded");

  window.subscribeToChatChannel = function() {
    try {
      // Si ya hay una suscripción, no hagas nada
      if (subscription) {
        console.log("Already subscribed to ChatChannel, skipping...");
        return;
      }

      console.log("subscribeToChatChannel called at", new Date().toISOString());
      const conversationMeta = document.querySelector('meta[name="conversation-id"]');
      if (conversationMeta) {
        console.log("Found conversation meta tag");
        const conversationId = conversationMeta.content;
        const messagesContainer = document.getElementById("messages");
        const currentUserEmail = messagesContainer ? messagesContainer.dataset.currentUserEmail : null;

        console.log("Conversation ID:", conversationId);
        console.log("Messages Container:", messagesContainer);
        console.log("Current User Email:", currentUserEmail);

        if (conversationId && currentUserEmail) {
          console.log("Attempting to subscribe to ChatChannel");
          subscription = consumer.subscriptions.create(
            { channel: "ChatChannel", conversation_id: conversationId },
            {
              connected() {
                console.log(`Connected to ChatChannel for conversation ${conversationId}`);
              },
              disconnected() {
                console.log("Disconnected from ChatChannel");
                subscription = null; // Limpia la suscripción al desconectar
              },
              received(data) {
                console.log("Received data:", data);
                const messages = document.getElementById("messages");
                const messageDiv = document.createElement("div");
                messageDiv.id = `message-${data.id}`;
                messageDiv.className = `mb-2 ${data.user === currentUserEmail ? "text-end" : "text-start"}`;
                messageDiv.innerHTML = `<strong>${data.user}:</strong> ${data.content} <small class="text-muted">(${data.created_at})</small>`;
                messages.appendChild(messageDiv);
                messages.scrollTop = messages.scrollHeight;
              },
            }
          );
        } else {
          console.log("Missing conversationId or currentUserEmail");
        }
      } else {
        console.log("No conversation meta tag found");
        console.log("All meta tags:", document.querySelectorAll('meta'));
      }
    } catch (error) {
      console.error("Error in subscribeToChatChannel:", error);
    }
  };

  // Llama a la suscripción solo una vez al cargar el script
  window.subscribeToChatChannel();
} catch (error) {
  console.error("Error in chat_channel.js:", error);
}

console.log("chat_channel.js: Script finished loading at", new Date().toISOString());
