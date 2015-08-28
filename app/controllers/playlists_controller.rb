class PlaylistsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  
  def index
    @playlists = Playlist.all
  end

  def create
    @playlist = current_user.create_playlist(name: current_user.full_name)
    redirect_to playlist_path(@playlist)
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def embed
    @playlist = Playlist.find(params[:id])
    render :embed, layout: 'embed'
  end
  
end
