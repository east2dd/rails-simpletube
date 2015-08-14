# encoding: utf-8
require 'streamio-ffmpeg'
class VideoFileUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def store_dimensions
    if file && model
      img = MiniMagick::Image.open(file.path)
      model.width = img['width']
      model.height = img['height']
    end
  end

  process :store_dimensions

  private

  def store_dimensions
    if file && model
      movie = FFMPEG::Movie.new(file.path)
      model.duration = movie.duration
      model.width = movie.width
      model.height = movie.height
      model.thumbnail = movie.screenshot("tmp/thumbnail-#{Time.now.to_i}.jpg", :seek_time => movie.duration / 30) rescue nil
    end
  end
end
