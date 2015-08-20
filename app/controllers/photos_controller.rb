class PhotosController < ApplicationController
  before_filter :set_photo, only: [:show]
  before_filter :set_tags

  def index
    @photos = Photo.recent.page(params[:page]).per(36)
  end

  def show
  end

  def tag_cloud
    @tags = Photo.tag_counts_on(:tags)
  end

  def tag
    @photos = Photo.tagged_with(params[:id]).recent
    @photos = @photos.page(params[:page]).per(36)
    @tag = params[:id]
    render :index
  end

  def search
    @photos = Photo.search(params[:search])
    @photos = @photos.page(params[:page]).per(36)
  end

  def set_tags
    @tags = Photo.tag_counts_on(:tags)
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end
end