require 'spec_helper'

describe RelationshipsController do
  describe "post create" do
    context "for authenticated user" do
      let(:signed_in_user) { Fabricate(:user) }
      let(:user2) { Fabricate(:user) }

      before do
        set_current_user(signed_in_user)
        post :create, leader_id: user2.id
      end

      it "creates a relationship for a signed in user" do
        expect(signed_in_user.following_relationships.first.leader).to eq(user2)
      end

      it "includes the signed in user as the follower in the relationship" do
        expect(Relationship.first.follower.id).to eq(signed_in_user.id)
      end

      it "redirects to the people page" do
        expect(response).to redirect_to people_path
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 1 }
    end

    it "does not allow the current user to follow the leader twice" do
      signed_in_user = Fabricate(:user)
      set_current_user(signed_in_user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader_id: user2.id, follower_id: signed_in_user.id)
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(1)
    end

    it " does not allow one to follow themselves" do
      signed_in_user = Fabricate(:user)
      set_current_user(signed_in_user)
      post :create, leader_id: signed_in_user.id
      expect(Relationship.count).to eq(0)
    end
  end

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
