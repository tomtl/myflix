require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "With valid input" do
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to the home page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end

      it "makes the user follow the inviter" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter,
                                            recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com",
                              password: "password",
                              full_name: "Joe Johnson" },
                      invitation_token: invitation.token
        recipient = User.find_by(email: "joe@example.com")
        expect(recipient.follows?(inviter)).to be_truthy
      end

      it "makes the inviter follow the user" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter,
                                            recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com",
                              password: "password",
                              full_name: "Joe Johnson" },
                      invitation_token: invitation.token
        recipient = User.find_by(email: "joe@example.com")
        expect(inviter.follows?(recipient)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter,
                                            recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com",
                              password: "password",
                              full_name: "Joe Johnson" },
                      invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with invalid input" do
      before do
        post :create, user: { password: "password", full_name: "Tom Lee" }
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
    end

    context "sending out emails" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Quimby" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "send out email containing the user's name with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Quimby" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Quimby")
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { email: "joe@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "renders the new user page" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "redirects to expired token page for invalid token" do
      get :new_with_invitation_token, token: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end
end
