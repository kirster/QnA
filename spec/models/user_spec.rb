require 'rails_helper'

describe User do
  context 'association' do
    it { should have_many(:questions).dependent :destroy }
    it { should have_many(:answers).dependent :destroy } 
  end
  
  context 'validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
end