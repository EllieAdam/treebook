class Friendship < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  aasm :column => 'state', :whiny_transitions => false do
    state :pending, :initial => true
    state :accepted

    event :accept, :after => :send_acceptance_email do
      transitions :from => :pending, :to => :accepted
    end
  end

  def send_request_email
    UserNotifier.friend_requested(id).deliver_now
  end

  def send_acceptance_email
    UserNotifier.friend_request_accepted(id).deliver_now
  end
end
