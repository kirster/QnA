require 'rails_helper'

feature 'Create answer', %q{
  In order to contribute to community
  As an authenticated user
  I want to be able to give answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer with valid attributes' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content 'Give your answer'
    fill_in 'answer[body]', with: 'test answer'
    click_on 'Add answer'

    expect(page).to have_content 'Your answer was successfully created'
    expect(page).to have_content question.answers.last.body
    expect(current_path).to eq question_path(question) 
  end

  scenario 'Authenticated user tries to create answer with invalid attributes' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content 'Give your answer'
    fill_in 'answer[body]', with: ''
    click_on 'Add answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer' do 
    visit question_path(question)
    expect(page).to_not have_content 'Give your answer'
  end

end