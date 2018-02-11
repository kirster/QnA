require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question) }
  let(:another_question) { create(:question) }

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

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'checks if created question belongs to user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) } 
        expect(response).to redirect_to question_path(assigns :question)
      end
    end

    context 'with invalid nil attributes' do
      it 'doesn`t save question to database with nil attributes' do
        expect { post :create, params: { question: attributes_for(:nil_attributes)} }.to_not change(@user.questions, :count)
      end

      it 'again renders new view' do
        post :create, params: { question: attributes_for(:nil_attributes)}
        expect(response).to render_template :new
      end
    end

    context 'with invalid length-less attributes' do
      it 'doesn`t save question to database with length-less attributes' do
        expect { post :create, params: { question: attributes_for(:length_less_attributes)} }.to_not change(@user.questions, :count)
      end

      it 'again renders new view' do
        post :create, params: { question: attributes_for(:nil_attributes)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do

    before{ sign_in question.user }

    context 'Author deletes his question' do
      it 'deletes question from database' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'Non-author tries to delete a question' do
      let!(:another_user) { create(:user) }
      let!(:another_question) { create(:question, user: another_user) }

      it 'doesn`t delete question from database' do
        expect { delete :destroy, params: { id: another_question } }.to_not change(Question, :count)
      end

      it 'renders question view' do
        delete :destroy, params: { id: another_question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in question.user }

    context 'Author edits his question with valid attributes' do
      it 'updates question' do
        patch :update, params: { id: question, question: {title: 'aaaaaaaa', body: 'bbbbbb'}, format: :js } 
        question.reload
        expect(question.title).to eq 'aaaaaaaa'
        expect(question.body).to eq   'bbbbbb'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: {title: 'aaaaaaaa', body: 'bbbbbb'}, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'Author edits his question with invalid attributes' do
      it 'doesn`t update question' do
        patch :update, params: { id: question, question: {title: '', body: 'bb'}, format: :js }
        question.reload
        expect(question.title).to_not eq ''
        expect(question.body).to_not eq 'bb'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: {title: '', body: 'bb'}, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'Non-author tries to edit answer' do
      it 'doesn`t update question' do
        patch :update, params: { id: another_question, question: {title: 'aaaaaaaa', body: 'bbbbbb'}, format: :js } 
        question.reload
        expect(question.title).to_not eq 'aaaaaaaa'
        expect(question.body).to_not eq 'bbbbbb'
      end

      it 'renders update template' do
        patch :update, params: { id: another_question, question: {title: 'aaaaaaaa', body: 'bbbbbb'}, format: :js } 
        expect(response).to render_template :update
      end
    end

  end

end
