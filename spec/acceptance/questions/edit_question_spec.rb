require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to make some corrections
  As an question author 
  I want to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }

  scenario 'Non-authenticated user tries to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do

    scenario 'tries to edit his question', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.question' do
      fill_in 'Body', with: 'edited question'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit other user`s question' do
      sign_in another_user
      visit question_path(question)

      within ".question" do
        expect(page).to_not have_content 'Edit'
      end
    end
  end   

end