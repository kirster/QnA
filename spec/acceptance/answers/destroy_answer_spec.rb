require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to delete unhelpful answer
  As an authenticated user and author of this answer
  I want to be able to delete answer
} do

  given!(:user)      { create(:user) }
  given!(:question)  { create(:question, user: user) }
  given!(:answer)    { create(:answer, user: user, question: question) }

  given!(:another_user)    { create(:user) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to have_content 'Answer was successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete another user`s question' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
  
end