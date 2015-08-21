# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fill => [256, 256]
  end

  version :preview do
    process :resize_to_fit => [512, 512]
  end

  version :full do
    process :resize_to_fit => [1024, 1024]
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.tap(&:auto_orient)
    end
  end

  process :fix_exif_rotation
  # process :store_dimensions

  private

  def store_dimensions
    if file && model
      img = MiniMagick::Image.open(file.path)
    end
  end

end
