require 'rails_helper'

describe AttachmentsController do
  let!(:question) { create(:question) }
  let!(:answer) { create(:question) }
  let!(:question_attachment) { create(:attachment, attachable: question) }
  let!(:answer_attachment) { create(:attachment, attachable: answer) }
  let!(:another_user) { create(:user) }

  describe 'DELETE #destroy' do

    context 'Author of ' do
      context 'question' do
        before { sign_in question_attachment.attachable.user }

        it 'deletes question`s attachment' do
          expect { delete :destroy, params: { id: question_attachment }, format: :js}.to change(question.attachments, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: question_attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'answer' do
        before { sign_in answer_attachment.attachable.user }

        it 'deletes asnwers`s attachment' do
          expect { delete :destroy, params: { id: answer_attachment }, format: :js}.to change(answer.attachments, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer_attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Non-author of ' do
      before { sign_in another_user }

      context 'question' do
        it 'doesn`t delete question`s attachment' do
          expect { delete :destroy, params: { id: question_attachment }, format: :js}.to_not change(question.attachments, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: question_attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'answer' do
        it 'doesn`t delete asnwers`s attachment' do
          expect { delete :destroy, params: { id: answer_attachment }, format: :js}.to_not change(answer.attachments, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer_attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Non-authenticated user' do
      it 'tries to delete question attachment' do
        expect { delete :destroy, params: { id: question_attachment }, format: :js }.to_not change(question.attachments, :count)
      end
    end 

  end
end
