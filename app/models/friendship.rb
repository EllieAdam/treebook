class Friendship < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  aasm :column => 'state', :whiny_transitions => false do
    state :pending, :initial => true
    state :accepted
    state :requested

    event :accept, :after => [:send_acceptance_email, :accept_mutual_friendship!] do
      transitions :from => :pending, :to => :accepted
      transitions :from => :requested, :to => :accepted
    end
  end

  def self.request(user1, user2)
    transaction do
      friendship1 = create(user: user1, friend: user2, state: 'pending')
      friendship2 = create(user: user2, friend: user1, state: 'requested')

      friendship1.send_acceptance_email
      friendship1
    end
  end

  def send_request_email
    UserNotifier.friend_requested(id).deliver_now
  end

  def send_acceptance_email
    UserNotifier.friend_request_accepted(id).deliver_now
  end

  def mutual_friendship
    self.class.where({user_id: friend_id, friend_id: user_id}).first
  end

  def accept_mutual_friendship!
    #this accepts the mirrored friendship to let the original user know the friendhip was accepted
    mutual_friendship.update_attribute(:state, 'accepted')
  end
end
