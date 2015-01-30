class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  state_machine initial: :pending do
    after_transition on: :accept, do: :send_acceptance_email

    event :accept do
      transition any => :accepted
    end
  end

  def send_request_email
    UserNotifier.friend_requested(id).deliver_now
  end

  def send_acceptance_email
    UserNotifier.friend_request_accepted(id).deliver_now
  end
end
