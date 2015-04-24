require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Amy", description: "Video about Amy", category_id: 1)
    video.save
    expect(Video.last).to eq(video)
  end
end
