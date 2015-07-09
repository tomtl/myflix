module StripeWrapper
  class Charge
    attr_reader :response, :error_message

    def initialize(options = {})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          source: options[:source],
          amount: options[:amount],
          currency: "usd",
          description: options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message

    def initialize(options = {})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Customer.create(
          source: options[:source],
          plan: options[:plan],
          email: options[:customer_email]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end
