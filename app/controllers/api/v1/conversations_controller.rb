# app/controllers/api/v1/conversations_controller.rb
module Api
  module V1
    class ConversationsController < BaseController
      # GET /api/v1/conversations
      def index
        # Paciente: conversaciones donde es receiver
        # Secretary/Admin: conversaciones donde es sender
        conversations = case current_api_user.role
        when 'patient'
          Conversation.where(receiver_id: current_api_user.id)
        when 'secretary', 'admin'
          Conversation.where(sender_id: current_api_user.id)
        else
          []
        end

        conversations = conversations.includes(:sender, :receiver, :appointment, messages: :user)
                                    .order(updated_at: :desc)

        render json: conversations.map { |c| serialize_conversation(c) }
      end

      # GET /api/v1/conversations/:id
      def show
        conversation = Conversation.find(params[:id])
        return render_unauthorized unless authorized?(conversation)

        # Mark messages from the other user as read
        conversation.messages.where.not(user_id: current_api_user.id).unread.update_all(read_at: Time.current)

        messages = conversation.messages
                               .includes(:user)
                               .order(created_at: :asc)

        render json: {
          conversation: serialize_conversation(conversation),
          messages: messages.map { |m| serialize_message(m) }
        }
      end

      # GET /api/v1/conversations/unread_count
      def unread_count
        render json: { unread_count: current_api_user.unread_messages_count }
      end

      private

      def authorized?(conversation)
        conversation.sender_id == current_api_user.id ||
        conversation.receiver_id == current_api_user.id
      end

      def serialize_conversation(conversation)
        # Determinar quién es el "otro usuario" (no el current_user)
        other_user = if conversation.sender_id == current_api_user.id
          conversation.receiver
        else
          conversation.sender
        end

        {
          id: conversation.id,
          appointment: {
            id: conversation.appointment.id,
            date: conversation.appointment.date,
            time: conversation.appointment.time&.strftime('%H:%M'),
            treatment_details: conversation.appointment.treatment_details,
            status: conversation.appointment.status
          },
          other_user: {
            id: other_user.id,
            name: "#{other_user.first_name} #{other_user.last_name}",
            email: other_user.email,
            role: other_user.role
          },
          last_message: conversation.messages.last ? {
            content: conversation.messages.last.content,
            created_at: conversation.messages.last.created_at
          } : nil,
          unread_count: conversation.messages.where.not(user_id: current_api_user.id).unread.count,
          created_at: conversation.created_at,
          updated_at: conversation.updated_at
        }
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
