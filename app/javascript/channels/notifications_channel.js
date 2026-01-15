import consumer from "./consumer";

console.log("notifications_channel.js: Script started loading at", new Date().toISOString());

let notificationSubscription = null;

function showToast(message, senderName) {
  // Create toast container if it doesn't exist
  let toastContainer = document.getElementById('notification-toast-container');
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.id = 'notification-toast-container';
    toastContainer.className = 'position-fixed top-0 end-0 p-3';
    toastContainer.style.zIndex = '11';
    document.body.appendChild(toastContainer);
  }

  // Create toast element
  const toastId = `toast-${Date.now()}`;
  const toastHtml = `
    <div id="${toastId}" class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="toast-header">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#007bff" class="bi bi-chat-dots me-2" viewBox="0 0 16 16">
          <path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
          <path d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2z"/>
        </svg>
        <strong class="me-auto">Nuevo mensaje</strong>
        <small>ahora</small>
        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
      <div class="toast-body">
        <strong>${senderName}:</strong> ${message}
      </div>
    </div>
  `;

  toastContainer.insertAdjacentHTML('beforeend', toastHtml);

  // Auto-remove toast after 5 seconds
  setTimeout(() => {
    const toast = document.getElementById(toastId);
    if (toast) {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }
  }, 5000);

  // Play notification sound (optional)
  try {
    const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2teleR8fSJHa35dUJilvrNDciFMnLGWn0Nqjg1I8TqPW2JJhQDphqtTYj1hBP1+p2t2WZD0/VqrZ3J1tQT1Wq9jflmY/QFqr2t2TXz48Wqza3pZiQEJbq9rfllU3MVWq19ykZD5EYK3Z4JRNO0Jfq9rgmGFBQl2s2t6eaDlBW6za3JNVO0Rep9nckVc5QWCw2d+VWDdAYLHb4ZlbOEBgs9vjmVk4QGC029+WVTVBYLTc35ZZNEFQXJ+zypdiQkhgrNXcnmJAQl6r2N2gZj9AXKzX3Z1gPDxbq9fdnWE7O1mr1t6dYTw8Wava3ZpgOzxaqtfdmmA8PFip1t2aYDw6WKnW3ZhfPTtZqdbdmF08O1io1t2YXDw7WKnW3ZhcOztYqNbdmFw7O1io1t2YXDs7WKjW3ZhcOztYqNbdmFw7O1io1t2YXDs7WKjW3ZhcOztYqNbcmFw7O1io1tyYXDs7WKjW3JhcOztYqNbcmFw7O1io1tyYXDs7');
    audio.volume = 0.3;
    audio.play().catch(() => {}); // Ignore autoplay errors
  } catch (e) {
    // Audio not supported
  }
}

function updateBadge(unreadCount) {
  const badge = document.getElementById('unread-badge');
  const badgeLink = document.getElementById('messages-badge-link');

  if (unreadCount > 0) {
    if (badge) {
      badge.textContent = unreadCount > 99 ? '99+' : unreadCount;
    } else if (badgeLink) {
      // Create badge if it doesn't exist
      const newBadge = document.createElement('span');
      newBadge.id = 'unread-badge';
      newBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger';
      newBadge.textContent = unreadCount > 99 ? '99+' : unreadCount;
      badgeLink.appendChild(newBadge);
    }
  } else if (badge) {
    badge.remove();
  }
}

document.addEventListener("turbo:load", () => {
  console.log("notifications_channel.js: turbo:load fired at", new Date().toISOString());

  // Check if user is logged in (badge link exists means user has conversations)
  const badgeLink = document.getElementById('messages-badge-link');
  const userLoggedIn = document.querySelector('.navbar-text');

  if (userLoggedIn && !notificationSubscription) {
    console.log("notifications_channel.js: Subscribing to NotificationsChannel...");

    notificationSubscription = consumer.subscriptions.create(
      { channel: "NotificationsChannel" },
      {
        connected() {
          console.log("Connected to NotificationsChannel");
        },
        disconnected() {
          console.log("Disconnected from NotificationsChannel");
          notificationSubscription = null;
        },
        received(data) {
          console.log("NotificationsChannel received:", data);

          if (data.type === 'new_message') {
            // Update badge count
            updateBadge(data.unread_count);

            // Show toast notification (only if not on the conversation page)
            const currentConversationMeta = document.querySelector('meta[name="conversation-id"]');
            const isOnSameConversation = currentConversationMeta &&
              currentConversationMeta.content === data.conversation_id;

            if (!isOnSameConversation) {
              showToast(data.content_preview, data.sender_name);
            }
          }
        },
        rejected() {
          console.log("NotificationsChannel subscription rejected");
        }
      }
    );
  }
});

document.addEventListener("DOMContentLoaded", () => {
  // Also try on DOMContentLoaded for initial page load
  const event = new Event('turbo:load');
  document.dispatchEvent(event);
});

console.log("notifications_channel.js: Script finished loading at", new Date().toISOString());
