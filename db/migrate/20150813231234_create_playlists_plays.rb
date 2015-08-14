class CreatePlaylistsPlays < ActiveRecord::Migration
  def change
    create_table :playlists_plays do |t|
      t.integer :play_id, index: true
      t.integer :playlist_id, index: true
    end
  end
end
