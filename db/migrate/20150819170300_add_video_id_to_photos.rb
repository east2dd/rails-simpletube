class AddVideoIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :video_id, :integer
    add_index :photos, :video_id
  end
end
