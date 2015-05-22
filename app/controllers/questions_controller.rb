class QuestionsController < ApplicationController

  before_action :load_question, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  include Voted

  def index
    @question = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
        PrivatePub.publish_to'/index', question: @question.to_json
        redirect_to @question, notice: 'Your question successfully created.'

      else
        render :new
      end

  end

  def destroy
    if @question.destroy
      redirect_to root_path, notice: 'Question deleted'
    end
  end

  def update
    @question.update(question_params)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

end
