class PlaySerializer < ActiveModel::Serializer
  attributes :file_url
  has_one :playable

  def file_url
    object.playable.video.file_url
  end
end