class Admin::PhotosController < Admin::BaseController
  before_filter :set_photo, only: [:edit, :update, :destroy]
  def new
    @photo = Photo.new
  end

  def index
    @photos = Photo.recent.page(params[:page])
  end

  def featured
    @photos = Photo.featured.recent.page(params[:page])
    render :index
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    @photo.save
    redirect_to admin_photos_path
  end
  
  def destroy
    authorize @photo
    @photo.destroy
    redirect_to admin_photos_path
  end

  def update
    authorize @photo
    @photo.update_attributes(photo_params)
    redirect_to edit_admin_photo_path(@photo)
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :description, :file, :remove_file, :tag_list, :featured)
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end
end