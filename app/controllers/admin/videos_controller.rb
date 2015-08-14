class Admin::VideosController < Admin::BaseController
  before_filter :set_video, only: [:edit, :update, :destroy, :encode]

  def index
    @videos = Video.recent.page(params[:page])
  end

  def new
    @video = Video.new
  end

  def tag
  end

  def edit
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user
    if @video.save
      flash[:success] = "Created a video successfully."
      redirect_to admin_videos_path
    else
      render :edit
    end
  end

  def update
    if @video.update_attributes(video_params)
      flash[:success] = "Updated a video successfully."
      redirect_to edit_admin_video_path(@video)
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    flash[:success] = "Deleted a video successfully."
    redirect_to admin_videos_path
  end

  def encode
    flash[:success] = "Started to encode a video successfully. Wait several minutes."
    Video.delay.encode(@video.id)
    redirect_to edit_admin_video_path(@video)
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :file, :thumbnail, :tag_list, :category_id)
  end

  def set_video
    @video = Video.find(params[:id])
  end
end
