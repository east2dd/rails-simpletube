class CreateSubtitles < ActiveRecord::Migration
  def change
    create_table :subtitles do |t|
      t.integer :video_id
      t.string :title
      t.string :thumbnail
      t.integer :start_at

      t.timestamps
    end
    add_index :subtitles, :video_id
  end
end
