require 'rails_helper'

describe Vote do
  describe 'association' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  context 'validation' do
    it { should validate_presence_of :user }
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  end
end
