class Status < ActiveRecord::Base
  validates :content, presence: true, length: { minimum: 2 }
  validates :user, presence: { message: "that actually exists must be assigned!" }

  has_many :comments, dependent: :destroy
  belongs_to :user

  acts_as_votable

  self.per_page = 10

  # This will ignore the deleted_at when finding user who created the status
  def user
    User.unscoped { super }
  end
end
