class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  default_scope { order(best: :desc) }

  accepts_nested_attributes_for :attachments

  def make_best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
