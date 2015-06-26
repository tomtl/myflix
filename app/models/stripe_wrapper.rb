module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options = {})
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          source: options[:source],
          description: options[:description]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end
end
