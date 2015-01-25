class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :statuses, dependent: :destroy

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, (65 + rand(26)).chr],
      [:name, (65 + rand(26)).chr, rand(99)]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
