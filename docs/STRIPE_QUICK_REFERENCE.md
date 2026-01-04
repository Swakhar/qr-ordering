# Stripe Quick Reference

## Test Credit Cards

| Scenario | Card Number | Result |
|----------|-------------|---------|
| Success | `4242 4242 4242 4242` | Payment succeeds |
| Decline | `4000 0000 0000 0002` | Card declined |
| Insufficient funds | `4000 0000 0000 9995` | Insufficient funds |
| 3D Secure auth | `4000 0025 0000 3155` | Requires 3DS authentication |
| Expired card | `4000 0000 0000 0069` | Expired card |

**For all test cards:**
- Use any future expiry date (e.g., `12/34`)
- Use any 3-digit CVC (e.g., `123`)
- Use any ZIP/postal code

## Common Stripe CLI Commands

```bash
# Login to Stripe
stripe login

# Forward webhooks to local server
stripe listen --forward-to localhost:3007/stripe/webhook

# Trigger test events
stripe trigger payment_intent.succeeded
stripe trigger payment_intent.payment_failed

# View recent events
stripe events list

# Get specific payment intent
stripe payment_intents retrieve pi_xxx

# Refund a payment
stripe refunds create --payment-intent=pi_xxx

# List customers
stripe customers list

# Test webhook endpoint
stripe trigger payment_intent.succeeded --override payment_intent:metadata.order_id=123
```

## Rails Console Commands

```ruby
# Find order and check payment status
order = Order.find(123)
order.payments.pluck(:stripe_payment_intent, :status, :amount_cents)

# Check total paid vs total due
puts "Paid: €#{order.paid_cents/100.0} / Total: €#{order.total_cents/100.0}"

# Find payment by Stripe ID
payment = Payment.find_by(stripe_payment_intent: 'pi_xxx')

# Manually process a webhook (for testing)
payment.update!(status: 'succeeded')
order.update!(paid_cents: order.total_cents, status: 'paid')

# List recent payments
Payment.order(created_at: :desc).limit(10).each do |p|
  puts "Order #{p.order_id}: #{p.status} - €#{p.amount_cents/100.0}"
end
```

## Payment Flow Endpoints

| Action | Endpoint | Method |
|--------|----------|--------|
| Show payment page | `/pay/:order_id` | GET |
| Create payment intent | `/r/:slug/orders/:id/payment_intent` | POST |
| Process webhook | `/stripe/webhook` | POST |

## Debugging Checklist

- [ ] Check Stripe keys are set in `.env`
- [ ] Restart Rails server after changing env vars
- [ ] Verify webhook secret matches Stripe CLI output
- [ ] Check Rails logs for Stripe API errors
- [ ] View Stripe Dashboard → Developers → Logs
- [ ] Ensure amount is in cents (not euros)
- [ ] Confirm webhook endpoint is accessible
- [ ] Test with Stripe CLI before production

## Amount Formatting

```ruby
# Convert euros to cents (for Stripe API)
euros = 25.50
cents = (euros * 100).to_i  # => 2550

# Convert cents to euros (for display)
cents = 2550
euros = cents / 100.0       # => 25.5
formatted = "€#{sprintf('%.2f', euros)}"  # => "€25.50"
```

## Webhook Event Types

Our app handles these events:
- `payment_intent.succeeded` - Payment completed successfully
- `payment_intent.payment_failed` - Payment failed
- `payment_intent.canceled` - Payment canceled

## Production Checklist

- [ ] Switch to live API keys (pk_live_..., sk_live_...)
- [ ] Configure production webhook endpoint in Stripe Dashboard
- [ ] Test with real card (then refund immediately)
- [ ] Enable Stripe Radar for fraud prevention
- [ ] Set up email receipts
- [ ] Configure automatic payouts
- [ ] Test 3D Secure flows
- [ ] Monitor failed payments

## Support

- **Stripe Docs**: https://stripe.com/docs
- **Testing Guide**: https://stripe.com/docs/testing
- **API Reference**: https://stripe.com/docs/api
- **Support Chat**: Available 24/7 in Stripe Dashboard
