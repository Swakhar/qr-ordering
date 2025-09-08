class PaymentsController < ApplicationController
  protect_from_forgery except: :webhook

  def create_intent
    order = Order.find_by!(id: params[:id], restaurant: Restaurant.find_by!(slug: params[:restaurant_slug]))
    amount = (params[:amount_cents] || order.total_cents - order.paid_cents).to_i
    return render json: { error: "Invalid amount" }, status: 400 if amount <= 0 || amount > (order.total_cents - order.paid_cents)

    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: (order.restaurant.currency || "EUR").downcase,
      automatic_payment_methods: { enabled: true },
      metadata: { order_id: order.id, restaurant: order.restaurant.slug }
    )
    Payment.create!(order:, stripe_payment_intent: intent.id, amount_cents: amount, status: intent.status)
    render json: { client_secret: intent.client_secret, payment_intent: intent.id }
  end

  def webhook
    payload = request.raw_post
    sig = request.env["HTTP_STRIPE_SIGNATURE"]
    secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
    event = Stripe::Webhook.construct_event(payload, sig, secret)

    if %w[payment_intent.succeeded payment_intent.payment_failed payment_intent.canceled].include?(event["type"])
      pi = event["data"]["object"]
      if (p = Payment.find_by(stripe_payment_intent: pi["id"]))
        p.update!(status: pi["status"])
        if pi["status"] == "succeeded"
          o = p.order
          new_paid = [o.total_cents, o.paid_cents + p.amount_cents].min
          new_status = (new_paid >= o.total_cents) ? "paid" : o.status
          o.update!(paid_cents: new_paid, status: new_status)
          # Broadcast to kitchen via Turbo Streams if you like
        end
      end
    end
    head :ok
  rescue => e
    Rails.logger.error e
    head :bad_request
  end
end
