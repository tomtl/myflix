require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
  
  describe "#recent_videos" do
    let(:comedies) { Category.create(name: "Comedies") }
    
    it "returns videos by reverse chronological order by created_at" do
      video_created_yesterday = Fabricate(:video, category: comedies, created_at: 1.day.ago)
      video_created_today = Fabricate(:video, category: comedies)
      expect(comedies.recent_videos).to eq([video_created_today, video_created_yesterday])
    end
    
    it "returns all the videos if there are 6 or less" do
      video1 = Fabricate(:video, category: comedies)
      video2 = Fabricate(:video, category: comedies)
      expect(comedies.recent_videos.count).to eq(2)
    end
  
    it "returns 6 videos if there are more than 6 videos" do
      Fabricate.times(7, :video, category: comedies)
      expect(comedies.recent_videos.count).to eq(6)
    end
    
    it "returns the most recent 6 videos" do
      Fabricate.times(6, :video, category: comedies)
      tonight_show = Video.create(title: "Tonight Show",
        description: "Talk show", category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(tonight_show)
    end
        
    it "returns an empty array if the category does not have any videos" do
      expect(comedies.recent_videos).to eq([])
    end
  end
end
