require 'rails_helper'

describe AnswersController do
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question_id }}

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end  
  end

  describe 'POST #create' do
    before { answer }

    context 'with valid attributes' do
      it 'saves new answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer), 
                                      question_id: answer.question_id } }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id }
        expect(response).to redirect_to answer_path(assigns(:answer))
      end  
    end

   context 'with invalid attributes' do
    it 'doesn`t save answer to database' do
      expect { post :create, params: { answer: attributes_for(:invalid_answer), 
                                      question_id: answer.question_id } }.to_not change(Answer, :count)
    end

    it 'again renders new view' do
      post :create, params: { answer: attributes_for(:invalid_answer), question_id: answer.question_id }
      expect(response).to render_template :new
    end
   end 
  end
end
