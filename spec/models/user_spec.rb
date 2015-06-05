require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:reviews).order("created_at DESC") }
  
  describe "#queued_video?" do
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

  describe "#follows?" do
    it "returns true if the current user has a relationship with a specified other user" do
      signed_in_user = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, follower: signed_in_user, leader: user2)
      expect(signed_in_user.follows?(user2)).to be_truthy
    end

    it "returns false if the user does not have a following relationship with the current user" do
      signed_in_user = Fabricate(:user)
      leader = Fabricate(:user)
      different_user = Fabricate(:user)
      Fabricate(:relationship, follower: signed_in_user, leader: leader)
      expect(signed_in_user.follows?(different_user)).to be_falsey
    end
  end

  describe "#can_follow?" do
    it "returns false if the user is already following the other user" do
      signed_in_user = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, follower: signed_in_user, leader: user2)
      expect(signed_in_user.can_follow?(user2)).to be_falsey
    end

    it "returns false if the user trys to follow themselves" do
      user1 = Fabricate(:user)
      expect(user1.can_follow?(user1)).to be_falsey
    end

    it "returns true if the use can follow the other user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      expect(user1.can_follow?(user2)).to be_truthy
    end
  end
end
