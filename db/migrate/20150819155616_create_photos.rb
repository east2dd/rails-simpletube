class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.text :description
      t.string :file
      t.integer :width
      t.integer :height
      t.integer :user_id
      t.timestamps
    end

    add_index :photos, :user_id
  end
end
