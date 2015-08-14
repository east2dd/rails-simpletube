class Admin::SubtitlesController < Admin::BaseController
  before_filter :set_video
  def create
    @subtitle = @video.subtitles.new(subtitle_params)
    @subtitle.thumbnail = @video.screen_shot_at(subtitle_params[:start_at].to_i)
    @subtitle.save
    @subtitle.video.update_meta_tags()
    redirect_to edit_admin_video_path(@video, subtitle_id: @subtitle.id)
  end
  
  def destroy
    @video.subtitles.find(params[:id]).destroy
    redirect_to edit_admin_video_path(@video)
  end

  def update
    @subtitle = @video.subtitles.find(params[:id])
    @subtitle.update_attributes(subtitle_params)
    @subtitle.video.update_meta_tags()
    redirect_to edit_admin_video_path(@video, subtitle_id: @subtitle.id)
  end

  def edit
    @subtitle = Subtitle.find(params[:id])
  end

  private

  def subtitle_params
    params.require(:subtitle).permit(:title, :start_at, :end_at, :description)
  end

  def set_video
    @video = Video.find(params[:video_id])
  end
end
