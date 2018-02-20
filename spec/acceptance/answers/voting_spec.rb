require_relative '../acceptance_helper'

feature 'Answer voting', %q{
  In order to rate any answer
  As an authenticated user
  I'd like to be able to give/cancel votes
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do 
    context 'Not answer`s author did not vote before' do
      before do
        sign_in user
        visit question_path(question) 
      end 

      scenario 'plus vote', js: true do 
        within "#answer_#{answer.id}" do
          expect(page).to have_link 'Like'
          click_on 'Like'
          expect(find('.rating')).to have_content '1'
        end
      end

      scenario 'minus vote', js: true do
        within "#answer_#{answer.id}" do
          expect(page).to have_link 'Dislike'
          click_on 'Dislike'
          expect(find('.rating')).to have_content '-1'
        end
      end

      scenario 'cancel vote', js: true do
        within "#answer_#{answer.id}" do
          expect(page).to have_link 'Cancel your vote'
          click_on 'Cancel your vote'
          expect(page).to have_content 'Can`t cancel vote'
        end
      end   
    end

    context 'Not question`s author voted before' do
      before do
        sign_in user
        visit question_path(question) 
      end 

      scenario 'vote', js: true do
        create(:vote, user: user, votable: answer)

        within "#answer_#{answer.id}" do
          expect(page).to have_link 'Like'
          click_on 'Like'
          expect(page).to have_content 'You are not able to vote' 
        end 
      end

      scenario 'cancel vote', js: true do
        create(:vote, user: user, votable: answer)

        within "#answer_#{answer.id}" do
          expect(page).to have_link 'Cancel your vote'
          click_on 'Cancel your vote'
          expect(find('.rating')).to have_content '0'
        end
      end
    end

    context 'Question`s author' do  
      before do
        sign_in answer.user
        visit question_path(question)
      end

      scenario 'plus vote', js: true do
        within "#answer_#{answer.id}" do
          expect(page).to_not have_link 'Like'
        end
      end

      scenario 'minus vote', js: true do
        within "#answer_#{answer.id}" do
          expect(page).to_not have_link 'Dislike'
        end
      end

      scenario 'cancel vote', js: true do
        within "#answer_#{answer.id}" do
          expect(page).to_not have_content 'Can`t cancel vote'
        end
      end
    end 
  end

  context 'Non-authenticated user' do
    scenario 'doesnt see links' do
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(find('.rating')).to have_content '0'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to_not have_content 'Can`t cancel vote' 
      end
    end
  end 

end