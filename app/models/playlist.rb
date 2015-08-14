class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :plays
  belongs_to :user
end