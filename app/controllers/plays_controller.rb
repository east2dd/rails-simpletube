class PlaysController < ApplicationController
  before_filter :authenticate_user!
  def destroy
    @play = current_user.playlist.plays.find(params[:id])
    current_user.playlist.plays.delete(@play)
    flash[:success] = "Removed a play from playlist successfully."
    redirect_to playlist_path(current_user.playlist)
  end
end
