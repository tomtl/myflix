module StripeWrapper
  class Charge
    def self.create(options = {})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: "usd",
        source: options[:card],
        description: options[:description]
      )
    end
  end
end
