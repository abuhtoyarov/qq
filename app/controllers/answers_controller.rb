class AnswersController < ApplicationController
  before_action :authenticate_user!, any: [:new, :create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    redirect_to question_path(@question)
    if @answer.save
     flash[:notice]='Your answer successfully created.'
    else
      flash[:notice]='Your answer not created.'
    end
  end

  def new
    @answer = Answer.new
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    if @answer.destroy
      redirect_to question_path(@question), notice: 'Answer deleted'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
