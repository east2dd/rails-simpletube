class Play < ActiveRecord::Base
  has_and_belongs_to_many :playlists
  belongs_to :playable, polymorphic: true

  def video
    self.playable.video
  end
end