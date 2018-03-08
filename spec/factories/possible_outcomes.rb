# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :possible_outcome do
    skip_create
    possible_outcome_set
  end
end
