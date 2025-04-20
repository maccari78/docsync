class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find_by(id: params[:conversation_id])
    if conversation
      stream_for conversation
    else
      reject
    end
  end
end
