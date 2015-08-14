class SubtitlesController < ApplicationController
  before_filter :set_sort_and_filter
  before_filter :authenticate_user!, only: [:add_to_playlist]
  def index
    @subtitles = Subtitle.recent.page(params[:page])

    if !params[:tag].blank?
      @subtitles = Subtitle.tagged_with(params[:tag])
    else
      if @sort_by
        @subtitles = Subtitle.order("#{@sort_by} #{@sort_direction}")
      else
        @subtitles = Subtitle.recent
      end
    end

    @subtitles = @subtitles.where(category_id: @category.id) if !@category.blank?
    @subtitles = @subtitles.where("created_at >= ?", @start_date) if @start_date
    @subtitles = @subtitles.where("created_at <= ?", @end_date) if @end_date
    @subtitles = @subtitles.page(params[:page])
  end

  def add_to_playlist
    @subtitle = Subtitle.find(params[:id])

    if @subtitle.play.blank?
      @subtitle.create_play
    end

    current_user.playlist.plays << @subtitle.play
    redirect_to playlist_path(current_user.playlist)
  end

  def set_sort_and_filter
    @sort_by = params[:sort_by]
    @sort_direction = params[:sort_direction] || 'desc'

    @start_date = Time.parse(params[:start_date]) rescue nil
    @end_date = Time.parse(params[:end_date]) rescue nil
  end
end
