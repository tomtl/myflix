class RelationshipsController < ApplicationController
  before_filter :require_user

  def create
    @leader = User.find(params[:leader_id])
    @relationship = Relationship.new(follower_id: current_user.id, leader_id: @leader.id)

    if current_user.can_follow?(@leader) && @relationship.save
      redirect_to people_path
    else
      flash[:error] = "You are not allowed to do that."
      redirect_to people_path
    end
  end

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    @relationship = Relationship.find(params[:id])

    if current_user.is_follower?(@relationship)
      @relationship.destroy
      flash[:message] = "You are no longer following #{@relationship.leader.full_name}"
      redirect_to people_path
    else
      flash[:error] = "You are not allowed to do that."
      redirect_to people_path
    end
  end
end
