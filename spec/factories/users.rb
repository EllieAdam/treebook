FactoryGirl.define do

  factory :user do
    pass = Faker::Internet.password(8)
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@treebook.com" }
    password pass
    password_confirmation pass
  end

end
