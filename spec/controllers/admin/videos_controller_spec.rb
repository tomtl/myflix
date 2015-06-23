require "spec_helper"

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets @video" do
      user = Fabricate(:admin)
      set_current_user(user)
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
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
      let(:category) { Fabricate(:category) }

      before do
        set_current_admin
        post :create, video: { title: "Monk",
                               category_id: category.id,
                               description: "Detective show" }
      end

      it "sets @video" do
        expect(assigns(:video)).to be_present
      end

      it "saves the video" do
        expect(category.videos.count).to eq(1)
      end

      it "displays success message" do
        expect(flash[:success]).to be_present
      end

      it "redirects to add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end
    end

    context "with invalid input" do
      before do
        set_current_admin
        post :create, video: { title: "Monk" }
      end

      it "does not save the video" do
        expect(Video.count).to eq(0)
      end

      it "sets @video" do
        expect(assigns(:video)).to be_present
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets the flash error message" do
        expect(flash[:error]).to be_present
      end
    end

    context "for user who is not an admin" do
      it "does not save video" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, video: { category_id: 1 }
        expect(Video.count).to eq(0)
      end
    end
  end
end
