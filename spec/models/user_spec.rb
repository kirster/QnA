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
  end
  
  context 'validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  context 'User is an author of' do

    context 'question' do
      it 'returns true if user is an author' do
        expect(user.author?(question)).to eq true
      end

      it 'returns false if user is not an author' do
        expect(user.author?(another_question)).to eq false
      end
    end

    context 'answer' do
      it 'returns true if user is an author' do
        expect(user.author?(answer)).to eq true
      end

      it 'returns false if user is not an author' do
        expect(user.author?(another_answer)).to eq false
      end
    end
  end
end