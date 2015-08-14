class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
