require "spec_helper"

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        inviter = Fabricate(:user)
        invitation = Fabricate(
          :invitation,
          inviter: inviter,
          recipient_email: "joe@example.com"
        )
        post :create,
          user: {
            email: "joe@example.com",
            password: "password",
            full_name: "Joe Johnson"
          },
          invitation_token: invitation.token
        recipient = User.find_by(email: "joe@example.com")
        expect(recipient.follows?(inviter)).to be_truthy
      end

      it "makes the inviter follow the user" do
        inviter = Fabricate(:user)
        invitation = Fabricate(
          :invitation,
          inviter: inviter,
          recipient_email: "joe@example.com"
        )
        post :create,
             user: {
               email: "joe@example.com",
               password: "password",
               full_name: "Joe Johnson"
             },
             invitation_token: invitation.token
        recipient = User.find_by(email: "joe@example.com")
        expect(inviter.follows?(recipient)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        inviter = Fabricate(:user)
        invitation = Fabricate(
          :invitation,
          inviter: inviter,
          recipient_email: "joe@example.com"
        )
        post :create,
             user: {
               email: "joe@example.com",
               password: "password",
               full_name: "Joe Johnson"
             },
             invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "joe@example.com",
                              password: "password",
                              full_name: "Joe Quimby" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "send out email containing the user's name with valid inputs" do
        post :create, user: { email: "joe@example.com",
                              password: "password",
                              full_name: "Joe Quimby" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Quimby")
      end
    end

    context "with valid personal info and declined credit card" do
      let(:charge) do
        double(
          :charge,
          successful?: false,
          error_message: "Your card was declined."
        )
      end

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create,
             user: Fabricate.attributes_for(:user),
             stripeToken: "1234567"
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        post :create, user: { email: "joe@example.com" }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not charge the credit card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send out welcome email" do
        expect(ActionMailer::Base.deliveries).to be_empty
        ActionMailer::Base.deliveries.clear
      end
    end

  end
end
