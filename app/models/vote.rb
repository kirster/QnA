class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, presence: true
  validates :value, inclusion: [-1, 1]
end
