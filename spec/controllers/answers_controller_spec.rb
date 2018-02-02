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
end
