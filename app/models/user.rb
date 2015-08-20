class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_commontator
  acts_as_marker
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :videos
  
  has_one :playlist
  has_many :photos

  def full_name
    return "UnNamed" if self.first_name.blank? && self.last_name.blank?
    "#{first_name} #{last_name}"
  end
end
