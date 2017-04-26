# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end

  factory :admin_user, parent: :user, class: User do
    after(:create, &:admin!)
  end
end
