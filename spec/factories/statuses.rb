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

FactoryGirl.define do

  factory :status do
    content { Faker::Lorem.sentence }
    association :user, factory: :user
  end

end
