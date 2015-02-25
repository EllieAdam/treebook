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
