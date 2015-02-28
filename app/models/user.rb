# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  admin                  :boolean          default("f")
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  slug                   :string
#  deleted_at             :datetime
#  image_file_name        :string
#  image_content_type     :string
#  image_file_size        :integer
#  image_updated_at       :datetime
#  provider               :string
#  uid                    :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#

class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :statuses
  has_many :comments
  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: { state: 'accepted' }).order('name DESC') }, :through => :friendships
  has_many :pending_friendships, -> { where(state: 'pending') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend
  has_many :requested_friendships, -> { where(state: 'requested') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :requested_friends, through: :requested_friendships, source: :friend
  has_many :blocked_friendships, -> { where(state: 'blocked') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :blocked_friends, through: :blocked_friendships, source: :friend
  has_many :accepted_friendships, -> { where(state: 'accepted') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :accepted_friends, through: :accepted_friendships, source: :friend

  has_attached_file :image,
              styles: { icon: "28x28^", small: "74x74^", medium: "100x100^" },
              convert_options: {
                icon: " -gravity center -crop '28x28+0+0'",
                small: " -gravity center -crop '74x74+0+0'",
                medium: " -gravity center -crop '100x100+0+0'" },
              default_style: :small,
              storage: :s3,
              url: ':s3_alias_url',
              s3_host_alias: 'd3qsrkjdadnces.cloudfront.net',
              bucket: ENV['S3_BUCKET'],
              path: "images/:class/:basename_:id.:style.:extension"
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  acts_as_voter
  acts_as_paranoid

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:facebook, :google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20])
    end
    user
  end

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

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end
end
