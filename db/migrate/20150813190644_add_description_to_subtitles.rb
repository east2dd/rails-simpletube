class AddDescriptionToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :description, :text
  end
end
