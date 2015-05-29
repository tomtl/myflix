class RelationshipsController < ApplicationController
  before_filter :require_user
  
  def index
    @relationships = current_user.following_relationships
  end
  
  def destroy
    @relationship = Relationship.find(params[:id])
    
    if follower_is_current_user?
      @relationship.destroy
      flash[:message] = "You are no longer following #{@relationship.leader.full_name}"
      redirect_to people_path
    else
      flash[:error] = "You are not allowed to do that."
      redirect_to people_path
    end
  end
  
  private
    def follower_is_current_user?
      current_user == @relationship.follower
    end
end