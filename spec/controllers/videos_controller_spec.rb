require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      before do
        john = User.create(email: "example@example.com", password: "password", full_name: "John John")
        session[:user_id] = john.id
      end

      it "sets the @video variable" do
        futurama = Video.create(title:"Futurama", description: "Space travel")
        get :show, id: Video.first.id
        expect(assigns(:video)).to eq(futurama)
      end

      it "renders the show template" do
        futurama = Video.create(title:"Futurama", description: "Space travel")
        get :show, id: Video.first.id
        response.should render_template :show
      end
    end
  end

  describe "GET search" do
    context "with authenticated users" do
      before do
        john = User.create(email: "example@example.com", password: "password", full_name: "John John")
        session[:user_id] = john.id
      end

      it "sets the @search variable" do
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
