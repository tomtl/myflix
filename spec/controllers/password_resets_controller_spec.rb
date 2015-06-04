require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      user = Fabricate(:user, token: '12345')
      get :show, id: user.token
      expect(response).to render_template(:show)
    end
    
    it "redirects to the expired token page if the toekn is not valid"
  end
end