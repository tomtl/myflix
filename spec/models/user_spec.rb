require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:reviews).order("created_at DESC") }
  
  describe "queued_video?" do
    it "returns true when the user queued the video" do
      user1 = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user1, video: video)
      expect(user1.queued_video?(video)).to be true
    end
    
    it "returns false when the user hasn't queued the video" do
      user1 = Fabricate(:user)
      video = Fabricate(:video)
      expect(user1.queued_video?(video)).to be false
    end
  end
end