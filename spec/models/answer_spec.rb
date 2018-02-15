require 'rails_helper'

describe Answer do
  describe 'association' do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many(:attachments).dependent :destroy }
    it { should have_many(:votes).dependent :destroy }
  end

  context 'validation' do
    it { should validate_presence_of :body }
  end

  describe 'attributes' do
    it { should accept_nested_attributes_for :attachments }
  end 

  describe 'best answer' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:another_answer) { create(:answer, question: question) }
    let!(:answers) { create_list(:answer, 3, question: question) }

    it 'makes answer best' do
      answer.make_best!
      answer.reload
      expect(answer).to be_best
    end

    it 'sets only one best answer' do
      answers.each do |answer|
        answer.make_best! 
        answer.reload 
        expect(question.answers.where(best: true).count).to eq 1
      end 
    end

    it 'sets best answer at top' do
      last_answer = answers.last
      last_answer.make_best!
      expect(Answer.all.first).to eq last_answer 
    end 
  end

end
