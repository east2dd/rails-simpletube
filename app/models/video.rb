class Video < ActiveRecord::Base
  acts_as_taggable
  acts_as_commontable
  acts_as_votable

  markable_as :favorite
  
  is_impressionable counter_cache: true
  
  mount_uploader :file, VideoFileUploader
  mount_uploader :thumbnail, VideoThumbnailUploader
  scope :recent, ->{ order(created_at: :desc) }
  scope :most_viewed, ->{ order('impressions_count DESC') }
  scope :most_scored, ->{ order('votes_score DESC') }
  scope :most_voted, ->{ order('upvotes_count DESC') }

  has_many :subtitles, -> { order('start_at ASC') }, dependent: :destroy
  belongs_to :category
  belongs_to :user
  has_one :play, as: :playable

  after_create :encode_video_file

  validates_presence_of :title

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  def update_meta_tags
    tags = self.tag_list || []
    tags << self.category.try(:name)
    self.meta_tags = (self.subtitles.map(&:title) + tags).join(', ')
    self.save
  end

  def refresh_metadata
    movie = FFMPEG::Movie.new(self.file.path)
    self.duration = movie.duration
    self.width = movie.width
    self.height = movie.height
    self.thumbnail = movie.screenshot("tmp/thumbnail-#{self.id}-#{seconds}.jpg", :seek_time => 10)
    self.save
  end

  def screen_shot_at(seconds)
    movie = FFMPEG::Movie.new(self.file.path)
    movie.screenshot("tmp/thumbnail-#{self.id}-#{seconds}.jpg", :seek_time => seconds)
  end

  def self.encode(id)
    video = Video.find(id)
    if !video.playable? and video.status!='encoding'
      video.status = 'encoding'
      video.save

      movie = FFMPEG::Movie.new(video.file.path)
      file_extension = File.extname(video.file.path)
      file_name = File.basename(video.file.path, file_extension)
      new_file_name = "tmp/#{file_name}-#{Time.now.to_s(:number)}.mp4"
      video.file = movie.transcode(new_file_name){ |progress| puts progress }
      video.status = 'encoded'
      video.save
    end
  end

  def playable?
    if self.status=='encoding'
      return false
    elsif self.status=='encoded'
      return true
    end

    return false if !self.file?

    black_list = ['.vob', '.flv', '.ts']
    white_list = ['.mp4', '.m4v', '.webm', '.ogg', '.mov']
    return false unless white_list.include? File.extname(self.file.path).downcase

    movie = FFMPEG::Movie.new(self.file.path)
    codec = movie.video_codec || ""
    return true if codec.include?('h264')
    return false
  end

  def encode_video_file
    unless self.playable?
      Video.delay_for(10.seconds).encode(self.id)
    end
  end

  def score
    self.get_upvotes.size - self.get_downvotes.size
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title^10', 'description', 'meta_tags']
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            title: {},
            description: {},
            meta_tags: {}
          }
        }
      }
    )
  end

end

Video.import
