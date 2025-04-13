class StripeController < ApplicationController
    # Desactiva la verificación CSRF para el webhook
    skip_before_action :verify_authenticity_token, only: [:webhook]
  
    def webhook
      logger.info "Webhook request received at #{Time.now.utc}"
  
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
      logger.info "Received webhook payload: #{payload}"
      logger.info "Signature header: #{sig_header}"
      logger.info "Endpoint secret: #{endpoint_secret}"
  
      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue Stripe::SignatureVerificationError => e
        logger.error "Webhook signature verification failed: #{e.message}"
        return head :bad_request # Esto devuelve un 422
      rescue JSON::ParserError => e
        logger.error "Invalid payload: #{e.message}"
        return head :bad_request # Esto también devuelve un 422
      end
  
      logger.info "Event type: #{event['type']}"
      if event['type'] == 'checkout.session.completed'
        session = event['data']['object']
        payment_id = session['metadata']['payment_id']
        logger.info "Processing payment_id: #{payment_id}"
        payment = Payment.find_by(id: payment_id)
        if payment
          logger.info "Found payment: #{payment.inspect}"
          begin
            payment.update(status: 'approved')
            logger.info "Payment approved for appointment #{payment.appointment_id}"
            # Enviar correo si está configurado
          rescue StandardError => e
            logger.error "Failed to update payment: #{e.message}"
            return head :unprocessable_entity # Esto devuelve un 422
          end
        else
          logger.error "Payment not found for session: #{session['id']}"
          return head :not_found
        end
      end
  
      head :ok
    end
  end