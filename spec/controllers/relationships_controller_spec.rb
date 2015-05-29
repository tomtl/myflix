require 'spec_helper'

describe RelationshipsController do
  describe "GET people" do
    it "sets @relationships to the current users following relationships" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  
  describe "DELETE destroy" do
    it "deletes the relationship if the current user is signed in" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    
    it "redirects to the people page" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
   end
    
    it "does not delete the relationship if the current user is not the follower" do
      signed_in_user = Fabricate(:user)
      set_current_user(signed_in_user)
      follower = Fabricate(:user)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: follower, leader: leader)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end
end