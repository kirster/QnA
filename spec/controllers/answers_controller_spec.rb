require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer), 
                                      question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'checks if created answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end  
    end

   context 'with invalid attributes' do
    it 'doesn`t save answer to database' do
      expect { post :create, params: { answer: attributes_for(:invalid_answer), 
                                      question_id: question } }.to_not change(question.answers, :count)
    end

    it 'again renders question show view' do
      post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
      expect(response).to render_template 'questions/show'
    end
   end 
  end

  describe 'DELETE #destroy' do

    before{ sign_in answer.user }

    context 'Author deletes his answer' do
      it 'deletes answer from database' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'Non-author tries to delete a question' do
      let!(:another_user) { create(:user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }

      it 'doesn`t delete question from database' do
        expect { delete :destroy, params: { id: another_answer } }.to_not change(Answer, :count)
      end

      it 'renders question view' do
        delete :destroy, params: { id: another_answer }
        expect(response).to render_template :show
      end
    end
    
  end 
end
