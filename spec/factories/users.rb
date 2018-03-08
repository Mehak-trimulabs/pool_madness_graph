# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user do
    auth0_id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end

  factory :admin_user, parent: :user, class: User do
    admin true
  end
end
