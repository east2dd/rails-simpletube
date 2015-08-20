class PhotosController < ApplicationController
  before_filter :set_photo, only: [:show]
  def index
    @photos = Photo.recent.page(params[:page])
  end

  def show
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end
end