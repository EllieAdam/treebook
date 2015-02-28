# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string
#
# Indexes
#
#  index_friendships_on_state                  (state)
#  index_friendships_on_user_id_and_friend_id  (user_id,friend_id)
#

FactoryGirl.define do
  factory :friendship do
    association :user, factory: :user
    association :friend, factory: :user

    factory :pending_friendship do
      state 'pending'
    end

    factory :requested_friendship do
      state 'requested'
    end

    factory :accepted_friendship do
      state 'accepted'
    end
  end

end
