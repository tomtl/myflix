require "spec_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      let(:token) do
        Stripe::Token.create(
          card: {
            number: card_number,
            exp_month: 6,
            exp_year: 2018,
            cvc: "314"
          },
        ).id
      end

      let(:charge) do
        StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "A charge description"
        )
      end

      context "with a valid card", :vcr do
        let(:card_number) { "4242424242424242" }

        it "makes a successful charge" do
          expect(charge).to be_successful
        end

        it "charges the correct amount" do
          expect(charge.response.amount).to be(999)
        end
      end

      context "with an invalid card", :vcr do
        let(:card_number) { "4000000000000002" }

        it "does not charge the card" do
          expect(charge).not_to be_successful
        end

        it "contains an error message" do
          expect(charge.error_message).to be_present
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      let(:token) do
        Stripe::Token.create(
          card: {
            number: card_number,
            exp_month: 6,
            exp_year: 2018,
            cvc: "314"
          },
        ).id
      end

      let(:create_customer) do
        StripeWrapper::Customer.create(
          source: token,
          plan: "tomtl-myflix-monthly-plan",
          email: "joe@example.com"
        )
      end

      context "with a valid card", :vcr do
        let(:card_number) { "4242424242424242" }

        it "outputs a successful message" do
          expect(create_customer.successful?).to be true
        end

        it "outputs the Stripe customer id" do
          expect(create_customer.stripe_customer_id).to be_present
        end

        it "signs the user up to the correct plan" do
          plan = create_customer.response.subscriptions.data.last.plan.id
          expect(plan).to eq("tomtl-myflix-monthly-plan")
        end
      end

      context "with invalid card", :vcr do
        let(:card_number) { "4000000000000002" }

        it "is not successful" do
          expect(create_customer.successful?).to be false
        end

        it "outputs an error message" do
          expect(create_customer.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end
