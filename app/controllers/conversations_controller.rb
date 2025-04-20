class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @conversation = Conversation.find(params[:id])
    redirect_to appointments_path, alert: 'You do not have access' unless authorized?(@conversation)
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = @conversation.messages.build
  end

  private

  def authorized?(conversation)
    conversation.sender == current_user || conversation.receiver == current_user
  end
end
