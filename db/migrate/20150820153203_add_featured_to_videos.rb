class AddFeaturedToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :featured, :boolean
    add_index :videos, :featured
  end
end
