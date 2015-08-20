class Photo < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  belongs_to :video
  mount_uploader :file, PhotoUploader
  scope :recent, ->{ order(created_at: :desc) }
  scope :featured, ->{ where(featured: true) }

  validates_presence_of :title

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title^10', 'description']
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            title: {},
            description: {}
          }
        }
      }
    )
  end
end

Photo.import