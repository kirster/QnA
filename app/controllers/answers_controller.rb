class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question

    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Answer was successfully deleted.'
    else
      flash.now[:alert] = 'You have no permission.'
      render 'questions/show'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
