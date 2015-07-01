require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a queue item that is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates a queue item that is associated with the signed in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it "puts the video as the last one in the queue" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      video1 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: user1, video: video1)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(
        video_id: video2.id,
        user: user1
      ).first

      expect(video2_queue_item.position).to eq(2)
    end

    it "does not add video to the queue if the video is already in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      video = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: alice, video: video)
      post :create, video_id: video.id
      expect(alice.queue_items.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: Fabricate(:video).id }
    end
  end

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      queue_item = Fabricate(:queue_item, user: user1)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue item positions" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      queue_item1 = Fabricate(
        :queue_item,
        user: user1,
        position: 1
      )
      queue_item2 = Fabricate(
        :queue_item,
        user: user1,
        position: 2
      )
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if it is not in the current user's queue" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      queue_item_user2 = Fabricate(:queue_item, user: user2)
      delete :destroy, id: queue_item_user2.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end

  describe "POST update_queue" do
    it_behaves_like "requires sign in" do
      let(:action) do
        post :update_queue, queue_items: [
          { id: 1, position: 2 },
          { id: 2, position: 1 }
        ]
      end
    end

    context "with valid inputs" do
      let(:user1) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item,
                                    user: user1,
                                    position: 1,
                                    video: video) }
      let(:queue_item2) { Fabricate(:queue_item,
                                    user: user1,
                                    position: 2,
                                    video: video) }

      before { set_current_user(user1) }

      it "redirects to the my queue page" do
        post :update_queue,
          queue_items: [
            { id: queue_item1.id, position: 2 },
            { id: queue_item2.id, position: 1 }
          ]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue,
          queue_items: [
            { id: queue_item1.id, position: 2 },
            { id: queue_item2.id, position: 1 }
           ]
        expect(user1.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue,
          queue_items: [
            { id: queue_item1.id, position: 3 },
            { id: queue_item2.id, position: 4 }
          ]
        expect(user1.queue_items.map(&:position)).to eq([1,2])
      end
    end

    context "with invalid inputs" do
      let(:user1) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item,
                                    user: user1,
                                    position: 1,
                                    video: video) }
      let(:queue_item2) { Fabricate(:queue_item,
                                    user: user1,
                                    position: 2,
                                    video: video) }

      before { set_current_user(user1) }

      it "redirects to the my queue page" do
        post :update_queue,
          queue_items: [
            { id: queue_item1.id, position: 2.1 },
            { id: queue_item2.id, position: 1 }
          ]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash[:error] message" do
        post :update_queue,
          queue_items: [
            { id: queue_item1.id, position: 2.1 },
            { id: queue_item2.id, position: 1 }
          ]
        expect(flash[:error]).to be_present
      end

      it "does not change the my queue items" do
        post :update_queue,
          queue_items: [
            { id: queue_item1.id, position: 2 },
            { id: queue_item2.id, position: 1.1 }
          ]
        expect(queue_item1.position).to eq(1)
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        set_current_user(user1)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item,
                                user: user2,
                                position: 1,
                                video: video)
        queue_item2 = Fabricate(:queue_item,
                                user: user1,
                                position: 2,
                                video: video)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 4 },
                                          { id: queue_item2.id, position: 3 }]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
