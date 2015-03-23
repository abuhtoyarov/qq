class QuestionsController < ApplicationController

  def create
    @question = Question.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
