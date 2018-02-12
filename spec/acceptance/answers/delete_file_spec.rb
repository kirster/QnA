require_relative '../acceptance_helper'

feature 'Delete answers`s attached files', %q{
  In order to remove unnecessary files
  As an asnwers`s author
  I want to be able to delete attachment 
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_attachment) { create(:attachment, attachable: answer) }

  given!(:another_question) { create(:question) }  
  given!(:another_answer) { create(:answer, question: another_question) }
  given!(:another_answer_attachment) { create(:attachment, attachable: another_answer) }

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'author tries to delete attached file', js: true do
      visit question_path(question)
      expect(page).to have_link 'spec_helper.rb'
      click_on 'Delete file'
      expect(page).to_not have_link 'spec_helper.rb'
    end

    scenario 'non-author tries to delete attached file', js: true do
      visit question_path(another_question)
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Non-authenticated user tries to delete file', js: true do
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb'
    expect(page).to_not have_link 'Delete file'
  end
 
end 
  