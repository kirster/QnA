FactoryBot.define do
  factory :vote do
    user
    association :votable
    value 1
  end
end
