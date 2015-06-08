require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the fogot password page" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error" do
        post :create, email: ""
        expect(flash[:error]).to be_present
      end
    end

    context "with existing email" do
      it "redirects to the forgot password confirmation page" do
        user = Fabricate(:user, email: "joe@example.com")
        post :create, email: user.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "generates a random token" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(User.last.token).to be_present
      end

      it "sends an email to the email address" do
        user = Fabricate(:user, email: "joe@example.com")
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
    end

    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: "wrong@example.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        post :create, email: "wrong@example.com"
        expect(flash[:error]).to be_present
      end
    end
  end
end
