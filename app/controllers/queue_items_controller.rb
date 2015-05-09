class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless already_in_queue?(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    redirect_to my_queue_path
  end

  private
    def new_queue_item_position
      current_user.queue_items.count + 1
    end

    def already_in_queue?(video)
      QueueItem.find_by(user: current_user, video: video)
    end
end