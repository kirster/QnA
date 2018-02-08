class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update] 

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

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to root_path, notice: 'Question was successfully deleted.'
    else
      flash.now[:alert] = 'You have no permission.'
      render :show
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
