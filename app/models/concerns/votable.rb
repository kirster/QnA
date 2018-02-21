module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes
  end

  def give_plus_vote(user)
    votes.create(user: user, value: 1)
  end

  def give_minus_vote(user)
    votes.create(user: user, value: -1)
  end

  def cancel_vote(user)
    votes.where(user: user).delete_all
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end

  def rating
    votes.sum(:value)
  end

end