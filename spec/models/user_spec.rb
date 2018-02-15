require 'rails_helper'

describe User do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user) }
  let!(:another_question) { create(:question) }
  let!(:another_answer) { create(:question) }

  context 'association' do
    it { should have_many(:questions).dependent :destroy }
    it { should have_many(:answers).dependent :destroy }
    it { should have_many(:votes).dependent :destroy }  
  end
  
  context 'validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  context 'User is an author of' do

    context 'question' do
      it 'returns true if user is an author' do
        expect(user).to be_author(question)
      end

      it 'returns false if user is not an author' do
        expect(user).to_not be_author(another_question)
      end
    end

    context 'answer' do
      it 'returns true if user is an author' do
        expect(user).to be_author(answer)
      end

      it 'returns false if user is not an author' do
        expect(user).to_not be_author(another_answer)
      end
    end
  end
end