require "spec_helper"

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and credit card and no invitation" do
      let(:customer) do
        double(:customer, successful?: true, stripe_customer_id: "cus_1234")
      end

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(
          Fabricate.build(
            :user,
            email: "joe@example.com",
            full_name: "Joe Quimby"
          )
        ).sign_up(stripe_token: "some_stripe_token")
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "saves the user's Stripe customer id" do
        expect(User.last.stripe_customer_id).to be_present
      end

      it "sends out email to the user with valid inputs" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "send out email containing the user's name with valid inputs" do
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Quimby")
      end
    end

    context "with valid personal info and valid card and invitation" do
      let(:customer) do
        double(:customer, successful?: true, stripe_customer_id: "cus_1234")
      end

      let(:inviter) { Fabricate(:user) }
      let(:recipient) { User.find_by(email: "joe@example.com") }
      let(:invitation) do
        Fabricate(
          :invitation,
          inviter: inviter,
          recipient_email: "joe@example.com"
        )
      end

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(
          Fabricate.build(
            :user,
            email: invitation.recipient_email,
            full_name: "Joe Quimby"
          )
        ).sign_up(
          stripe_token: "some_stripe_token",
          invitation_token: invitation.token
        )
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        expect(User.count).to eq(2)
      end

      it "makes the user follow the inviter" do
        expect(recipient.follows?(inviter)).to be_truthy
      end

      it "makes the inviter follow the user" do
        expect(inviter.follows?(recipient)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid personal info and declined credit card" do
      let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined.") }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(
          Fabricate.build(:user)
        ).sign_up(stripe_token: "1234567")
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "is not successful" do
        expect(customer.successful?).to be false
      end

      it "returns an error message" do
        expect(customer.error_message).to eq("Your card was declined.")
      end
    end

    context "with invalid personal info" do
      let(:customer) { double(:customer, successful?: true) }

      it "does not create the user" do
        UserSignup.new(
          User.new(email: "joe@example.com")
        ).sign_up(stripe_token: "1234567")
        expect(User.count).to eq(0)
      end

      it "does not charge the credit card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(
          User.new(email: "joe@example.com")
        ).sign_up(stripe_token: "1234567")
      end

      it "does not send out welcome email" do
        UserSignup.new(
          User.new(email: "joe@example.com")
        ).sign_up(stripe_token: "1234567")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
