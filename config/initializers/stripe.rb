Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    Payment.create(
      user: User.find_by(stripe_customer_id: event.data.object.customer),
      amount: event.data.object.amount,
      reference_id: event.data.object.id
    )
  end
end
