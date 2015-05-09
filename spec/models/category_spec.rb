require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
  
  describe "#recent_videos" do
    it "returns videos by reverse chronological order by created_at" do
      comedies = Category.create(name: "Comedies")
      futurama = Video.create(title: "Futurama", description: "Space travel",
        category: comedies, created_at: 1.day.ago)
      southpark = Video.create(title: "South Park", description: "Crazy kids!",
        category: comedies)
      expect(comedies.recent_videos).to eq([southpark, futurama])
    end
    
    it "returns all the videos if there are 6 or less" do
      comedies = Category.create(name: "Comedies")
      futurama = Video.create(title: "Futurama", description: "Space travel",
        category: comedies, created_at: 1.day.ago)
      southpark = Video.create(title: "South Park", description: "Crazy kids!",
        category: comedies)
      expect(comedies.recent_videos.count).to eq(2)
    end
  
    it "returns 6 videos if there are more than 6 videos" do
      comedies = Category.create(name: "Comedies")
      7.times { Video.create(title: "foo", description: "bar",
        category: comedies)}
      expect(comedies.recent_videos.count).to eq(6)
    end
    
    it "returns the most recent 6 videos" do
      comedies = Category.create(name: "Comedies")
      6.times { Video.create(title: "foo", description: "bar",
        category: comedies) }
      tonight_show = Video.create(title: "Tonight Show",
        description: "Talk show", category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(tonight_show)
    end
        
    it "returns an empty array if the category does not have any videos" do
      comedies = Category.create(name: "Comedies")
      expect(comedies.recent_videos).to eq([])
    end
  end
end
