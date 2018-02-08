require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to make some corrections
  As an answer author
  I want to be able to edit my answer
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:another_user) { create(:user) }

  given!(:another_answer) { create(:answer, question: question) }

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    
    scenario 'tries to edit other user`s answer' do
      within "#answer_#{another_answer.id}" do
        expect(page).to_not have_content 'Edit'
      end
    end

  end 

end
