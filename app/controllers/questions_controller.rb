class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :build_answer, only: :show
  after_action  :publish_question, only: :create

  respond_to :html, :js


  include Voted

  authorize_resource

  def index
    respond_with(@question = Question.all)
  end

  def show
    respond_with @question
  end

  def new
   respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to('/index', question: @question.to_json) if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

end