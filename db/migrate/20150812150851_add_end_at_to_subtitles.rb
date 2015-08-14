class AddEndAtToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :end_at, :integer
  end
end
