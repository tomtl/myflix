class VideosController < ApplicationController
  def index
    @videos = Video.all
    @image_path = "/tmp/"
  end
  
  def show
    @video = Video.find(params[:id])
  end
end