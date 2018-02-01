class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: :show 

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
  end

  def show; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created'
    else
      render :new
    end 
  end

  private

  def question_params
    params.require(:question).permit :title, :body
  end

  def find_question
    @question = Question.find(params[:id])  
  end

end
