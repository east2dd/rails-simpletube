class AddMetaTagsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :meta_tags, :text
  end
end
