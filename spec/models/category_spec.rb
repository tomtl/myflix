require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  
  describe "#recent_videos" do
    it "returns videos by reverse chronological order by created_at" do
      comedies = Category.create(name: "Comedies")
      futurama = Video.create(title: "Futurama", description: "Space travel",
        category: comedies, created_at: 1.day.ago)
      southpark = Video.create(title: "South Park", description: "Crazy kids!",
        category: comedies)
      expect(comedies.recent_videos).to eq([southpark, futurama])
    end
    
    it "returns all the videos if there are 6 or less"
    it "returns 6 videos if there are more than 6 videos"
    it "returns the most recent 6 videos"
    it "returns an empty array if the category does not have any videos"
  end
end
