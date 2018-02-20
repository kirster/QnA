require 'rails_helper'

describe AnswersController do
  let!(:question)       { create(:question) }
  let!(:answer)         { create(:answer) }
  let!(:another_answer) { create(:answer) }
  let!(:another_question) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer), 
                                      question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'checks if created answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end  
    end

   context 'with invalid attributes' do
    it 'doesn`t save answer to database' do
      expect { post :create, params: { answer: attributes_for(:invalid_answer), 
                                      question_id: question, format: :js } }.to_not change(question.answers, :count)
    end

    it 'renders create template' do
      post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
      expect(response).to render_template :create
    end
   end 
  end

  describe 'DELETE #destroy' do

    before{ sign_in answer.user }

    context 'Author deletes his answer' do
      it 'deletes answer from database' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Non-author tries to delete a question' do
      let!(:another_user) { create(:user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }

      it 'doesn`t delete question from database' do
        expect { delete :destroy, params: { id: another_answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: another_answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
    
  end

  describe 'PATCH #update' do
    before { sign_in answer.user }

    context 'Author edits his answer with valid attributes' do
      it 'updates answer' do
        patch :update, params: { id: answer, answer: {body: '12345'}, format: :js } 
        answer.reload
        expect(answer.body).to eq '12345'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: {body: '12345'}, format: :js } 
        expect(response).to render_template :update
      end
    end

    context 'Author edits his answer with invalid attributes' do
      it 'doesn`t update answer' do
        patch :update, params: { id: answer, answer: {body: ''}, format: :js } 
        answer.reload
        expect(answer.body).to_not eq ''
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: {body: ''}, format: :js } 
        expect(response).to render_template :update
      end
    end

    context 'Non-author tries to edit answer' do
      it 'doesn`t update answer' do
        patch :update, params: { id: another_answer, answer: {body: '1111'}, format: :js } 
        answer.reload
        expect(answer.body).to_not eq '1111'
      end

      it 'renders update template' do
        patch :update, params: { id: another_answer, answer: {body: '11111'}, format: :js } 
        expect(response).to render_template :update
      end
    end

  end

  describe 'PATCH #make_best' do
    before { sign_in question.user }
    let!(:answer) { create(:answer, question: question) }

    context 'Question`s author marks answer best' do
      before { patch :make_best, params: { id: answer, format: :js } }

      it 'makes answer best' do
        expect(answer.reload).to be_best
      end

      it 'renders make_best template' do 
        expect(response).to render_template :make_best
      end
    end

    context 'Not question author tries to mark answer best' do
      sign_in_user

      it 'doesn`t make answer best' do
        patch :make_best, params: { id: answer, format: :js } 
        answer.reload
        expect(answer).to_not be_best
      end

      it 'renders make_best template' do
        patch :make_best, params: { id: answer, format: :js }  
        expect(response).to render_template :make_best
      end
    end
  end

  describe 'POST#create_vote' do 
    context 'non-author tries to vote' do
      sign_in_user

      context 'non-author did not vote before' do
        it 'saves new vote' do
          expect { post :create_vote, params: { id: answer.id, plus: true }}.to change(answer.votes, :count).by (1)
        end

        it 'responces 200 status' do
          post :create_vote, params: { id: answer.id, plus: true }
          expect(response).to have_http_status 200
        end  
      end

      context 'non-author voted before' do
        before {  post :create_vote, params: { id: answer.id, plus: true } }

        it 'doesn`t save new vote' do
          expect { post :create_vote, params: { id: answer.id }}.to_not change(answer.votes, :count)
        end

        it 'responses 403 status' do
          post :create_vote, params: { id: answer.id }
          expect(response). to have_http_status 403
        end

        it 'renders error' do
          post :create_vote, params: { id: answer.id }
          expect(response.body).to have_content 'You are not able to vote'
        end   
      end
    end

    context 'author tries to vote' do
      before { sign_in answer.user }

      it 'doesn`t save new vote' do
        expect { post :create_vote, params: { id: answer.id }}.to_not change(answer.votes, :count)
      end

      it 'responses 403 status' do
        post :create_vote, params: { id: answer.id }
        expect(response).to have_http_status 403
      end

      it 'renders error' do
        post :create_vote, params: { id: answer.id }
        expect(response.body).to have_content 'You are not able to vote'
      end 
    end
  end

  describe 'DELETE#destroy_vote' do 
    context 'non-author tries to cancel' do
      sign_in_user

      context 'non-author did not vote before' do
        it 'doesn`t delete vote' do
          expect { delete :delete_vote, params: { id: answer.id}}.to_not change(answer.votes, :count)
        end

        it 'responces 403 status' do
          delete :delete_vote, params: { id: answer.id}
          expect(response). to have_http_status 403
        end

        it 'renders error' do
          delete :delete_vote, params: { id: answer.id }
          expect(response.body).to have_content 'Can`t cancel vote'
        end   
      end

      context 'non-author voted before' do
        before {  post :create_vote, params: { id: answer.id } }

        it 'deletes vote' do
          expect { delete :delete_vote, params: { id: answer.id }}.to change(answer.votes, :count).by(-1)
        end

        it 'responses 200 status' do
          delete :delete_vote, params: { id: answer.id }
          expect(response). to have_http_status 200
        end   
      end
    end

    context 'author tries to cancel vote' do
      before { sign_in answer.user }

      it 'doesn`t delete vote' do
        expect { delete :delete_vote, params: { id: answer.id }}.to_not change(answer.votes, :count)
      end

      it 'responses 403 status' do
        delete :delete_vote, params: { id: answer.id }
        expect(response). to have_http_status 403
      end

      it 'renders error' do
        delete :delete_vote, params: { id: answer.id }
        expect(response.body).to have_content 'Can`t cancel vote'
      end 
    end
  end

  
end
