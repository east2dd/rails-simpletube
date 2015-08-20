class VideosController < ApplicationController
  before_filter :set_category, :set_most_viewed
  impressionist :actions=>[:show]

  before_filter :set_sort_and_filter
  before_filter :set_subtitle

  before_filter :authenticate_user!, only: [:favorite, :unfavorite]
  layout :set_wide_layout, only: [:wide]

  def show
    @video = Video.find(params[:id])
    @video.impressions_count = @video.impressionist_count
    @video.save
  end
  
  def tag_cloud
    @tags = Video.tag_counts_on(:tags)
  end

  def index
    if !params[:tag].blank?
      @videos = Video.tagged_with(params[:tag])
    else
      if @sort_by
        @videos = Video.order("#{@sort_by} #{@sort_direction}")
      else
        @videos = Video.recent
      end
    end

    @videos = @videos.where(category_id: @category.id) if !@category.blank?
    @videos = @videos.where("created_at >= ?", @start_date) if @start_date
    @videos = @videos.where("created_at <= ?", @end_date) if @end_date
    @videos = @videos.page(params[:page]).per(12)
  end

  def search
    @videos = Video.search(params[:search])
    @videos = @videos.page(params[:page])
  end

  def most_viewed
    @title = "Most viewed"
    @videos = Video.most_viewed.page(params[:page])
    render :index
  end

  def most_voted
    @title = "Recommended"
    @videos = Video.most_voted.page(params[:page])
    render :index
  end

  def most_scored
    @title = "Top videos"
    @videos = Video.most_scored.page(params[:page])
    render :index
  end

  def tag
    @videos = Video.tagged_with(params[:id])
    @videos = @videos.order("#{@sort_by} #{@sort_direction}") if @sort_by
    @videos = @videos.page(params[:page])
    @tag = params[:id]
    render :index
  end

  def download
    @video = Video.find(params[:id])
    redirect_to @video.file.url
  end

  def upvote
    @video = Video.find(params[:id])
    @video.upvote_by current_user
    @video.upvotes_count = @video.get_upvotes.count
    @video.votes_score = @video.upvotes_count - @video.downvotes_count
    @video.save
    redirect_to video_path(@video)
  end

  def downvote
    @video = Video.find(params[:id])
    @video.downvote_by current_user
    @video.downvotes_count = @video.get_downvotes.count
    @video.votes_score = @video.upvotes_count - @video.downvotes_count
    @video.save
    redirect_to video_path(@video)
  end

  def favorite
    @video = Video.find(params[:id])
    current_user.favorite_videos << @video
    current_user.save
    flash[:success] = "Added a video to favorites successfully."
    if params[:redirect]
      redirect_to params[:redirect]
    else
      redirect_to video_path(@video)
    end
  end

  def unfavorite
    @video = Video.find(params[:id])
    current_user.favorite_videos.delete @video
    flash[:success] = "Removed a video from favorites successfully."

    if params[:redirect]
      redirect_to params[:redirect]
    else
      redirect_to video_path(@video)
    end
  end

  def wide
    @video = Video.find(params[:id])

  end

  def set_wide_layout
    'wide'
  end

  def capture_photo
    @video = Video.find(params[:id])
    if !params[:video_at].blank?
      @photo = Photo.new
      @photo.file = @video.screen_shot_at(params[:video_at].to_f)
      @photo.title = "#{@video.title} #{Time.now.to_f}"
      @photo.video_at = params[:video_at].to_i
      @photo.video = @video
      @photo.save

      redirect_to edit_admin_photo_path(@photo)
    else
      redirect_to :back
    end
  end

  def embed
    @video = Video.find(params[:id])
    render :embed, layout: 'embed'
  end

  private
  def set_category
    @category = Category.find(params[:category_id]) rescue nil
  end

  def set_most_viewed
    @most_viewed = Video.order('impressions_count DESC').take(10)
  end

  def set_sort_and_filter
    @sort_by = params[:sort_by]
    @sort_direction = params[:sort_direction] || 'desc'

    @start_date = Time.parse(params[:start_date]) rescue nil
    @end_date = Time.parse(params[:end_date]) rescue nil
  end

  def set_subtitle
    @subtitle = Subtitle.find(params[:subtitle_id]) if params[:subtitle_id]
  end
end
