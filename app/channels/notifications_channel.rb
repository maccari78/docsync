class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "NotificationsChannel: User #{current_user.email} subscribed"
    stream_for current_user
  end

  def unsubscribed
    Rails.logger.info "NotificationsChannel: User #{current_user.email} unsubscribed"
  end
end
