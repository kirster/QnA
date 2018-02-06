require_relative '../acceptance_helper'

feature 'User can view all questions', %q{
  In order to know actual problems of other users
  As a User
  I want to be able to read questions 
} do

  given(:user) { create(:user) }
  let!(:questions) { create_list(:question, 3) }

  scenario 'Logged user can view questions' do
    questions = create_list(:question, 3)
    sign_in(user)

    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }   
  end

  scenario 'Guest can view questions' do
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }    
  end
end 