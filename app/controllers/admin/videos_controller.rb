class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    
    if @video.save
      flash[:success] = "The video has been created!"
      redirect_to videos_path(@video)
    else
      render :new
    end
  end
  
  private
    def video_params
      params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
    end
end