class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "User"

  validates_presence_of :leader_id, :follower_id
  validates_uniqueness_of :leader_id, scope: :follower_id
end
