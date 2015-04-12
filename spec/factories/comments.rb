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

FactoryGirl.define do

  factory :comment do
    body { Faker::Lorem.sentence }
    association :user, factory: :user
    association :status, factory: :status
  end

end
