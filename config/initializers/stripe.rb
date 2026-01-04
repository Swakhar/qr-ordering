# frozen_string_literal: true

# Stripe Configuration
# This initializer sets up Stripe for payment processing
# Make sure to set the following environment variables:
# - STRIPE_PUBLISHABLE_KEY (for client-side)
# - STRIPE_SECRET_KEY (for server-side API calls)
# - STRIPE_WEBHOOK_SECRET (for webhook signature verification)

Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY'],
  webhook_secret: ENV['STRIPE_WEBHOOK_SECRET']
}

# Set the API key for Stripe SDK
Stripe.api_key = Rails.configuration.stripe[:secret_key]

# Log Stripe configuration status (without exposing secrets)
Rails.logger.info "Stripe Configuration:"
Rails.logger.info "  - Publishable Key: #{ENV['STRIPE_PUBLISHABLE_KEY'] ? '✓ Set' : '✗ Missing'}"
Rails.logger.info "  - Secret Key: #{ENV['STRIPE_SECRET_KEY'] ? '✓ Set' : '✗ Missing'}"
Rails.logger.info "  - Webhook Secret: #{ENV['STRIPE_WEBHOOK_SECRET'] ? '✓ Set' : '✗ Missing'}"

# Warn if keys are missing in production
if Rails.env.production? && (ENV['STRIPE_SECRET_KEY'].blank? || ENV['STRIPE_PUBLISHABLE_KEY'].blank?)
  Rails.logger.warn "⚠️  WARNING: Stripe keys not configured in production!"
end
