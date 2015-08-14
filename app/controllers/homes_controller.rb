class HomesController < ApplicationController
  def index
    @videos = Video.recent
  end
end
