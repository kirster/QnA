require 'rails_helper'

feature 'Delete question', %q{
  In order to delete unncecessary question
  As an authenticated user and author of this question
  I want to be able to delete questions
} do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question, user: user) }

  given!(:another_user)    { create(:user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Question was successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user tries to delete another user`s question' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
  
end