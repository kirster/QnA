require 'rails_helper'

describe Question do

  context 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least 3 }
    it { should validate_length_of(:body).is_at_least 5 }
  end

end