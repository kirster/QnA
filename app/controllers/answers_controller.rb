class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:destroy, :update, :make_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def make_best
    @answer.make_best! if current_user.author?(@answer.question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit :body, attachments_attributes: [:file, :id, :_destroy]
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
