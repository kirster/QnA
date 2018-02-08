require 'rails_helper'

describe AnswersController do
  let!(:question)       { create(:question) }
  let!(:answer)         { create(:answer) }
  let!(:another_answer) { create(:answer) }


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

end
