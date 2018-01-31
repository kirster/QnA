class AnswersController < ApplicationController
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: :show

  def new
    @answer = @question.answers.new    
  end
  
  def show; end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
