class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @question = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])
    if @question.destroy
      redirect_to root_path, notice: 'Question deleted'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
