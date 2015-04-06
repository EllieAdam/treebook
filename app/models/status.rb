# == Schema Information
#
# Table name: statuses
#
#  id                :integer          not null, primary key
#  content           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#  cached_votes_up   :integer          default(0)
#  cached_votes_down :integer          default(0)
#  comments_count    :integer          default(0), not null
#
# Indexes
#
#  index_statuses_on_cached_votes_down  (cached_votes_down)
#  index_statuses_on_cached_votes_up    (cached_votes_up)
#  index_statuses_on_user_id            (user_id)
#

class Status < ActiveRecord::Base
  include PublicActivity::Common

  validates :content, presence: true, length: { minimum: 2 }
  validates :user, presence: { message: "that actually exists must be assigned!" }

  has_many :comments, dependent: :destroy
  belongs_to :user, -> { with_deleted }

  acts_as_votable

  self.per_page = 10

  # This will ignore the deleted_at when finding user who created the status
  def user
    User.unscoped { super }
  end
end
