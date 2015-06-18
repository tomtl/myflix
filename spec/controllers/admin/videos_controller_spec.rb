require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    
    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end
    
    it "sets @video" do
      user = Fabricate(:user, admin: true)
      set_current_user(user)
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end
  
  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end
    
    it_behaves_like "requires admin" do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end
    
    context "with valid input" do
      it "sets @video" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        video = Fabricate.attributes_for(:video)
        post :create, video: video
        expect(assigns(:video)).to be_instance_of(Video)
      end
      
      it "saves the video" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        video = Fabricate.attributes_for(:video)
        post :create, video: video
        expect(Video.count).to eq(1)
      end
      
      it "displays success message" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        video = Fabricate.attributes_for(:video)
        post :create, video: video
        expect(flash[:success]).to be_present
      end
      
      it "redirects to video page" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        video = Fabricate.attributes_for(:video)
        post :create, video: video
        expect(response).to redirect_to videos_path(Video.first)
      end
    end
    
    context "with invalid input" do
      it "does not save the video" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        post :create, video: { category_id: 1 }
        expect(Video.count).to eq(0)
      end
      
      it "sets @video" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        post :create, video: { category_id: 1 }
        expect(assigns(:video)).to be_present
      end
      
      it "renders the new template" do
        user = Fabricate(:user, admin: true)
        set_current_user(user)
        post :create, video: { category_id: 1 }
        expect(response).to render_template(:new)
      end
    end
    
    context "for user who is not an admin" do
      it "does not save video" do
        user = Fabricate(:user, admin: false)
        set_current_user(user)
        post :create, video: { category_id: 1 }
        expect(Video.count).to eq(0)
      end
    end
  end
end