class Category < ActiveRecord::Base
  acts_as_nested_set :order_column => :position
  has_many :videos

  has_many :subtitles, through: :videos
end
