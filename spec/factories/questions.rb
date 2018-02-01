FactoryBot.define do
  factory :question do
    title "MyString"
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
