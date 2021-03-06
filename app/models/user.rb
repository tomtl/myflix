class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password

  has_many :queue_items, -> { order('position') }
  has_many :reviews, -> { order('created_at DESC') }
  has_many :following_relationships, class_name: "Relationship",
                                     foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship",
                                   foreign_key: :leader_id
  has_many :payments

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow(leader)
    if self.can_follow?(leader)
      following_relationships.create(leader_id: leader.id)
    end
  end

  def follows?(another_user)
    following_relationships.pluck(:leader_id).include? another_user.id
  end

  def follower?(relationship)
    self == relationship.follower
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || another_user == self)
  end

  def generate_token!
    update_column(:token, SecureRandom.urlsafe_base64)
  end

  def clear_token!
    update_column(:token, "")
  end

  def deactivate!
    update_column(:active, false)
  end
end
