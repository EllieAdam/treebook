class User < ActiveRecord::Base
  include Gravtastic
  gravtastic  :secure => true,
              :size => 70

  acts_as_voter

  validates :name, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :statuses, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :pending_friendships, -> { where(state: 'pending') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :friends, -> { where(friendships: { state: 'accepted' }).order('name DESC') }, :through => :friendships
  has_many :pending_friends, :through => :pending_friendships, source: :friend

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
