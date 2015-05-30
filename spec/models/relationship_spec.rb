require 'spec_helper'

describe Relationship do
  it { should validate_presence_of(:leader_id) }
  it { should validate_presence_of(:follower_id) }
  it { should belong_to(:leader) }
  it { should belong_to(:follower) }
end
