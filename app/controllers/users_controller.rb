class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def photos
    @user = User.find(params[:id])
    @photos = @user.photos.recent.page(params[:page])
  end

  def videos
    @user = User.find(params[:id])
    @videos = @user.videos.recent.page(params[:videos])
  end
end
