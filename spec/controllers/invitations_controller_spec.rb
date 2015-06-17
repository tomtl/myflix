require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith",
                                    recipient_email: "joe@example.com",
                                    message: "Example message" }
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates the invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "sends the invitation email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "redirects to the new invitation page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "sets the success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com",
                                    message: "Example message" }
      end

      it "sets the @invitation" do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end

      it "does not create the invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send out the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the error message" do
        expect(flash[:error]).to be_present
      end
    end
  end
end
