module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voted, only: [:create_vote, :delete_vote] 
  end

  def create_vote
    unless vote_permission?
      add_vote
    else
      render_error("You are not able to vote")
    end
  end

  def delete_vote
    if @resource.voted_by?(current_user)
      @resource.cancel_vote(current_user)
      render_success
    else
      render_error("Can`t cancel vote")
    end
  end

  private

  def find_voted
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def add_vote
    if params[:plus]
      @resource.give_plus_vote(current_user)
    else
      @resource.give_minus_vote(current_user)
    end
    render_success
  end

  def vote_permission?
    current_user.author?(@resource) || @resource.voted_by?(current_user)
  end

  def render_success
    render json: { rating: @resource.rating } 
  end

  def render_error(message)
    render json: { error_message: message, type: @resource.class.name }, status: :forbidden
  end

end