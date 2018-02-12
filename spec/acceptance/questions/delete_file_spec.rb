require_relative '../acceptance_helper'

feature 'Delete question`s attached files', %q{
  In order to remove unnecessary files
  As an question`s author
  I want to be able to delete attachment 
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_attachment) { create(:attachment, attachable: question) }
  given!(:another_question) { create(:question) }
  given!(:another_question_attachment) { create(:attachment, attachable: another_question) }

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
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Non-authenticated user tries to delete file', js: true do
    visit question_path(question)
    expect(page).to have_link 'spec_helper'
    expect(page).to_not have_link 'Delete file'
  end
 
end 
  