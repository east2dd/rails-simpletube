class AddFeaturedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :featured, :boolean
    add_index :photos, :featured
  end
end