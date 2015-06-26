require "spec_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      before { Stripe.api_key = ENV["STRIPE_SECRET_KEY"] }

      let(:token) do
        token = Stripe::Token.create(
            :card => {
              :number => card_number,
              :exp_month => 6,
              :exp_year => 2018,
              :cvc => "314"
            },
          ).id
        end

        let(:response) do
          response = StripeWrapper::Charge.create(
            amount: 999,
            source: token,
            description: "A charge description"
          )
        end

      context "with a valid card" do
        let(:card_number) { "4242424242424242" }

        it "makes a successful charge", :vcr do
          expect(response.response.paid).to be_truthy
        end

        it "charges the correct amount", :vcr do
          expect(response.response.amount).to be(999)
        end
      end

      context "with an invalid card" do
        let(:card_number) { "4000000000000002" }

        it "does not charge the card", :vcr do
          expect(response).not_to be_successful
        end

        it "contains an error message", :vcr do
          expect(response.error_message).to be_present
        end
      end
    end
  end
end
