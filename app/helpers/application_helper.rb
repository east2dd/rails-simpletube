module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper
  def random_videos(count)
    records = []

    (1..count).each do
      offset = rand(Video.where.not(thumbnail: nil).count)
      records << Video.where.not(thumbnail: nil).offset(offset).first
    end

    records
  end

  def random_subtitles(count)
    records = []

    (1..count).each do
      offset = rand(Subtitle.where.not(thumbnail: nil).count)
      records << Subtitle.where.not(thumbnail: nil).offset(offset).first
    end

    records
  end

  def random_photos(count)
    records = []

    (1..count).each do
      offset = rand(Photo.count)
      records << Photo.recent.offset(offset).first
    end

    records
  end

end
