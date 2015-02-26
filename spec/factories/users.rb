# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  admin                  :boolean          default("f")
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  slug                   :string
#  deleted_at             :datetime
#  image_file_name        :string
#  image_content_type     :string
#  image_file_size        :integer
#  image_updated_at       :datetime
#  provider               :string
#  uid                    :string
#

FactoryGirl.define do

  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@treebook.com" }
    password 'treebook2'
    password_confirmation 'treebook2'

    factory :admin do
      admin true
    end
  end

end
