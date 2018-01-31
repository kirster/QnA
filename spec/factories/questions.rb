FactoryBot.define do
  factory :question do
    title "MyString"
    body "MyText"
  end

  factory :nil_attributes, class: 'Question' do
    title nil
    body nil
  end

  factory :length_less_attributes, class: 'Question' do
    title 'my'
    body 'str'
  end
end
