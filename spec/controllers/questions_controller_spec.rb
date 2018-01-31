require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index}

    it 'fullfils questions array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end 
  end 

  describe 'GET #new' do 
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'redirects to show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user
    
    context 'with valid attributes' do
      it 'saves new question to database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) } 
        expect(response).to redirect_to question_path(assigns :question)
      end
    end

    context 'with invalid nil attributes' do
      it 'doesn`t save question to database with nil attributes' do
        expect { post :create, params: { question: attributes_for(:nil_attributes)} }.to_not change(Question, :count)
      end

      it 'again renders new view' do
        post :create, params: { question: attributes_for(:nil_attributes)}
        expect(response).to render_template :new
      end
    end

    context 'with invalid length-less attributes' do
      it 'doesn`t save question to database with length-less attributes' do
        expect { post :create, params: { question: attributes_for(:length_less_attributes)} }.to_not change(Question, :count)
      end

      it 'again renders new view' do
        post :create, params: { question: attributes_for(:nil_attributes)}
        expect(response).to render_template :new
      end
    end
  end 
end
