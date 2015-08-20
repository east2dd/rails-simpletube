class AddVideoAtToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :video_at, :integer
  end
end