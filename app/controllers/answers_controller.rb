class AnswersController < ApplicationController

  before_action :load_answer, only: [:show, :update, :destroy, :accept]
  before_action :load_question
  before_action :authenticate_user!, any: [:new, :create, :update, :accept]

  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.json { render :submit }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end


  def new
    @answer = Answer.new
    @answer.attachments.new
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
  end

  def show
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def accept
    @question.answers.update_all(best:nil)
    @answer.update(answer_params)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best, attachments_attributes: [:file, :_destroy, :id])
  end
end
