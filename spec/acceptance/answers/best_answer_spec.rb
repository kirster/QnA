require_relative '../acceptance_helper'

feature 'Best answer', %q{
  In order to choose best answer
  As a question author 
  I want to be able to mark answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'author question' do
      scenario 'see mark best link answer' do
        expect(page).to have_link 'Mark as best'
      end

      scenario 'choose the best', js: true do
        click_on 'Mark as best'
        expect(page).to have_content 'Best answer'
      end

      scenario 'does not see the link in a best', js: true do
        click_on 'Mark as best'
        expect(page).to_not have_link 'Mark best'
        expect(page).to have_content 'Best answer'
      end

      scenario 'choose another best', js: true do
        create(:answer, best: true, question: question)
        visit question_path(question)

        within "#answer_#{answer.id}" do
          click_on 'Mark as best'
        end

        within "#answer_#{answer.id}}" do
          expect(page).to have_content 'Best answer'
        end
      end

      scenario 'best answer first', js: true do
        answers = create_list(:answer, 3, question: question) 

        visit question_path(question)
        best_answer = answers.last

        within "#answer_#{best_answer.id}" do
          click_on 'Mark as best'
        end

        within all('.answers').first do
          expect(page).to have_content 'Best answer'
        end

      end
    end

    scenario 'not author question does not see link mark best' do
      another_question = create(:question)
      create(:answer, question: another_question)
      visit question_path(another_question)
      expect(page).to_not have_link 'Mark as best'
    end

  end

  scenario 'Non-authenticated user tries to choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end

end

