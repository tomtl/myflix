require 'spec_helper'

describe Myflix do
  it "saves itself" do
    video = Video.new(title: "Amy", description: "Video about Amy", category_id: 1)
    video.save
    expect(Video.first.title).to eq("Amy")
    expect(Video.first.description).to eq("Video about Amy")
  end
end
