require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }
end

describe "search by title" do
  let(:futurama) { Fabricate(:video, title:"Futurama") }
  let(:back_to_future) { Fabricate(:video, title: "Back to the Future") }

  it "returns an empty array if there is no match" do
    expect(Video.search_by_title("Hello")).to eq([])
  end

  it "returns an array of one video for an exact match" do
    expect(Video.search_by_title("Futurama")).to eq([futurama])
  end

  it "returns an array of one video for a partial match" do
    expect(Video.search_by_title("rama")).to eq([futurama])
  end

  it "returns an array of all matches ordered by created_at" do
    futurama.created_at = 1.day.ago
    back_to_future.created_at = Time.now
    expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
  end

  it "returns an empty array for a search with an empty string" do
    expect(Video.search_by_title("")).to eq([])
  end
end

describe "rating" do
  it "returns the correct rating" do
    video = Fabricate(:video)
    user1 = Fabricate(:user)
    Fabricate(:review, user: user1, rating: 5, video: video)
    expect(video.rating).to eq(5)
  end

  it "averages the rating for more than one review" do
    video = Fabricate(:video)
    user1 = Fabricate(:user)
    user2 = Fabricate(:user)
    Fabricate(:review, user: user1, rating: 1, video: video)
    Fabricate(:review, user: user2, rating: 5, video: video)
    expect(video.rating).to eq(3)
  end

  it "returns nil if no ratings are present" do
    video = Fabricate(:video)
    expect(video.rating).to be_nil
  end
end
