class AnswersController < ApplicationController
  before_action :authenticate_user!, any: [:new, :create, :update]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def new
    @answer = Answer.new
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    @answer.destroy
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best)
  end
end
