class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    redirect_to appointments_path, alert: 'You do not have access' unless authorized?(@conversation)
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      puts "Broadcasting to conversation #{@conversation.id}"
      ChatChannel.broadcast_to(@conversation, {
        id: @message.id,
        user: @message.user.email,
        user_name: "#{@message.user.first_name} #{@message.user.last_name}",
        content: @message.content,
        created_at: @message.created_at.strftime('%H:%M')
      })

      # Send notification to the other user
      recipient = @conversation.sender == current_user ? @conversation.receiver : @conversation.sender
      if recipient
        NotificationsChannel.broadcast_to(recipient, {
          type: 'new_message',
          conversation_id: @conversation.id,
          sender_name: "#{current_user.first_name} #{current_user.last_name}",
          content_preview: @message.content.truncate(50),
          unread_count: recipient.unread_messages_count
        })
      end

      redirect_to conversation_path(@conversation, anchor: "message-#{@message.id}")
    else
      @messages = @conversation.messages
      render 'conversations/show', status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def authorized?(conversation)
    conversation.sender == current_user || conversation.receiver == current_user
  end
end