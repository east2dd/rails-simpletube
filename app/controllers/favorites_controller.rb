class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  def index
    @videos = current_user.favorite_videos
  end
end
