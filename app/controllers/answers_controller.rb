class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    redirect_to questions_path(@question)
    if @answer.save
     flash[:notice]='Your answer successfully created'
    else
      flash[:notice]='Your answer not created'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
