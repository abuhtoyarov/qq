class AnswersController < ApplicationController

  before_action :load_answer, only: [:show, :update, :destroy, :accept]
  before_action :load_question, only: [:create, :accept]
  before_action :authenticate_user!, any: [:new, :create, :update, :accept]
  after_action  :publish_answer, only: :create
  before_action :find_question, only: :update

  respond_to :json, only: [:create, :update]
  respond_to :js

  include Voted

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def new
    respond_with(@answer = Answer.new)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def show
  end

  def update
     @answer.update(answer_params)
     respond_with @answer
  end

  def accept
    @question.answers.update_all(best:nil)
    @answer.update(answer_params)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = @answer.question
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string(:submit) if @answer.valid?
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best, attachments_attributes: [:file, :_destroy, :id])
  end
end
