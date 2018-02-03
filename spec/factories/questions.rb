FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end

  factory :question do
    title
    body "MyText"
    user
  end

  factory :nil_attributes, class: 'Question' do
    title nil
    body nil
    user
  end

  factory :length_less_attributes, class: 'Question' do
    title 'my'
    body 'str'
    user
  end
end
