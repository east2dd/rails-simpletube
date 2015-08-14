class Subtitle < ActiveRecord::Base
  belongs_to :video
  mount_uploader :thumbnail, VideoThumbnailUploader
  scope :recent, ->{ order(created_at: :desc) }
  validates_presence_of :title, :start_at

  validate :validate_positions
  has_one :play, as: :playable, dependent: :destroy

  def validate_positions
    if self.end_at
      errors.add(:end_at, "couldn't be over than start at position") if self.end_at.to_i < self.start_at.to_i
    end
  end
end
