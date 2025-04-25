pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true
pin "@rails/actioncable", to: "actioncable.esm.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
pin "channels/consumer", to: "channels/consumer.js", preload: true
pin "channels/chat_channel", to: "channels/chat_channel.js", preload: true