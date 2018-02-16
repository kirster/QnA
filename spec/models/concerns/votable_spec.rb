require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:resource) { create(described_class.to_s.underscore.to_sym) }

  describe 'give vote' do
    it 'adds a  vote' do
      expect { resource.give_plus_vote(user) }.to change(resource.votes, :count).by 1
      expect(resource.rating).to eq 1
    end

    it 'takes away a  vote' do
      expect { resource.give_minus_vote(user) }.to change(resource.votes, :count).by 1
      expect(resource.rating).to eq -1
    end 
  end

  describe 'cancel vote' do
    it 'deletes votes' do  
      resource.give_plus_vote(user)
      resource.cancel_vote(user)
      expect(resource.rating).to eq 0
    end 
  end

  describe 'voted by?' do
    it 'returns true if user gave a vote in past' do 
      resource.give_plus_vote(user)
      expect(resource.voted_by?(user)).to be true
    end

    it 'returns false if user did not give a vote in past' do 
      expect(resource.voted_by?(another_user)).to be false
    end
  end

  describe 'rating' do
    it 'returns amount of given votes' do
      resource.give_plus_vote(user)
      resource.give_plus_vote(another_user)
      expect(resource.rating).to eq 2
    end 
  end 

end