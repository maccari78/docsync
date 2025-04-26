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