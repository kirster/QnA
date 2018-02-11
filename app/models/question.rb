class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments
end
