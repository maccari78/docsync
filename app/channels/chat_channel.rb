class ChatChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "ChatChannel: Received conversation_id: #{params[:conversation_id]}"
    conversation = Conversation.find_by(id: params[:conversation_id])
    if conversation
      Rails.logger.info "ChatChannel: Found conversation #{conversation.id}, streaming for it"
      stream_for conversation
    else
      Rails.logger.error "ChatChannel: Conversation not found for ID: #{params[:conversation_id]}"
      reject
    end
  end

  def unsubscribed
    Rails.logger.info "ChatChannel: Unsubscribed from conversation_id: #{params[:conversation_id]}"
  end
end