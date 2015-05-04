require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it "redirects the user to the sign in page for unauthenticated user" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    context "with authenticated users" do
      before do
        john = User.create(email: "example@example.com", password: "password", full_name: "John John")
        session[:user_id] = john.id
      end

      it "sets the @search" do
        futurama = Video.create(title:"Futurama", description: "Space travel")
        get :search, search_term:  Video.first.title
        expect(assigns(:results)).to eq([futurama])
      end

      it "renders the search template" do
        futurama = Video.create(title:"Futurama", description: "Space travel")
        get :search, search_term: Video.first.title
        response.should render_template :search
      end
    end
  end
end
