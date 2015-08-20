class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  mount_uploader :file, PhotoUploader
  scope :recent, ->{ order(created_at: :desc) }

  validates_presence_of :title
end