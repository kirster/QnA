class Question < ApplicationRecord

  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true, length: { minimum: 5 }
  
end
