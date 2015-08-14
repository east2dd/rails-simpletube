class AddVisitsCounterCacheToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :impressions_count, :integer, default: 0
  end
end
