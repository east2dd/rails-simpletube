class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :file
      t.string :thumbnail

      t.timestamps
    end
  end
end
