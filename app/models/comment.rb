class Comment < ActiveRecord::Base
  validates :body, presence: true, length: { minimum: 2 }
  validates :user_id, presence: true
  validates :status_id, presence: true

  belongs_to :user
  belongs_to :status

  # This will ignore the deleted_at when finding user who created the comment
  def user
    User.unscoped { super }
  end
end
