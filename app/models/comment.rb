# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string
#  user_id    :integer
#  status_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_status_id  (status_id)
#  index_comments_on_user_id    (user_id)
#

class Comment < ActiveRecord::Base
  validates :body, presence: true
  validates :user, presence: { message: "that actually exists must be assigned!" }
  validates :status, presence: { message: "that actually exists must be assigned!" }

  belongs_to :user
  belongs_to :status, counter_cache: true

  # This will ignore the deleted_at when finding user who created the comment
  def user
    User.unscoped { super }
  end
end
