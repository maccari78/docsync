# app/controllers/api/v1/messages_controller.rb
module Api
  module V1
    class MessagesController < BaseController
      before_action :load_conversation
      before_action :check_authorization

      # GET /api/v1/conversations/:conversation_id/messages
      def index
        page = params[:page]&.to_i || 1
        per_page = 50

        messages = @conversation.messages
                                .includes(:user)
                                .order(created_at: :asc)
                                .limit(per_page)
                                .offset((page - 1) * per_page)

        render json: messages.map { |m| serialize_message(m) }
      end

      # POST /api/v1/conversations/:conversation_id/messages
      def create
        message = @conversation.messages.build(message_params)
        message.user = current_api_user

        if message.save
          # Broadcast mensaje a WebSocket (ChatChannel)
          ChatChannel.broadcast_to(@conversation, {
            id: message.id,
            user: message.user.email,
            user_id: message.user.id,
            user_name: "#{message.user.first_name} #{message.user.last_name}",
            content: message.content,
            created_at: message.created_at.strftime('%H:%M')
          })

          Rails.logger.info "Message #{message.id} created and broadcasted to conversation #{@conversation.id}"

          render json: serialize_message(message), status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/conversations/:conversation_id/messages/typing
      def typing
        # Broadcast indicador de escritura a TypingChannel
        TypingChannel.broadcast_to(@conversation, {
          user_id: current_api_user.id,
          user_name: "#{current_api_user.first_name} #{current_api_user.last_name}",
          typing: true
        })

        Rails.logger.info "Typing indicator sent by #{current_api_user.email} in conversation #{@conversation.id}"

        head :ok
      end

      private

      def load_conversation
        @conversation = Conversation.find(params[:conversation_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Conversation not found' }, status: :not_found
      end

      def check_authorization
        return if authorized?(@conversation)
        render_unauthorized
      end

      def authorized?(conversation)
        conversation.sender_id == current_api_user.id ||
        conversation.receiver_id == current_api_user.id
      end

      def message_params
        params.require(:message).permit(:content)
      end

      def serialize_message(message)
        {
          id: message.id,
          content: message.content,
          user_id: message.user_id,
          user_name: "#{message.user.first_name} #{message.user.last_name}",
          created_at: message.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          time: message.created_at.strftime('%H:%M')
        }
      end
    end
  end
end
