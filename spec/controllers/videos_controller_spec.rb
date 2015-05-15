require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video) }
    
    context "for authenticated users" do
      before { set_current_user }
      
      it "sets the @video for authenticated user" do
        set_current_user
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      
      it "sets the @reviews for authenticated users" do
        set_current_user
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST search" do
    it "sets the @results for authenticated users" do
      set_current_user
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, search_term:  "rama"
      expect(assigns(:results)).to eq([futurama])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :search, search_term:  Fabricate(:video).title }
    end
  end
end
