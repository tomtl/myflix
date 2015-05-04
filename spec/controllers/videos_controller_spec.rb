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

  describe "POST search" do
    it "sets the @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, search_term:  "rama"
      expect(assigns(:results)).to eq([futurama])
    end
    
    it "redirects to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :search, search_term:  video.title
      expect(response).to redirect_to sign_in_path
    end
  end
end
