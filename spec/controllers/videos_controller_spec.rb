require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video variable" do
      futurama = Video.create(title:"Futurama", description: "Space travel")
      back_to_future = Video.create(title: "Back to the Future", description: "Time travel")
      get :show
      assigns(:video).should == [futurama, back_to_future]
    end

    it "renders the show template"
  end
end
