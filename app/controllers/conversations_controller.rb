class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @conversation = Conversation.find(params[:id])
    redirect_to appointments_path, alert: 'You do not have access' unless authorized?(@conversation)
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = @conversation.messages.build

    # Mark messages from the other user as read
    @conversation.messages.where.not(user_id: current_user.id).unread.update_all(read_at: Time.current)
  end

  private

  def authorized?(conversation)
    conversation.sender == current_user || conversation.receiver == current_user
  end
end
