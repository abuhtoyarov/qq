class AnswersController < ApplicationController

  before_action :load_answer, only: [:show, :update, :destroy, :accept]
  before_action :load_question, only: [:create, :accept]
  before_action :authenticate_user!, any: [:new, :create, :update, :accept]

  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        #format.json { render :submit }
        format.json do
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: to_json
          render nothing: true
        end
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        format.js
      end
    end
  end


  def new
    @answer = Answer.new
    @answer.attachments.new
  end

  def destroy
    @answer.destroy
  end

  def show
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.json { render :submit }
        format.js
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        format.js
      end
      @question = @answer.question
    end
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

  def to_json
    Jbuilder.encode do |json|
      json.(@answer, :id, :body, :best, :user_id, :rating)

      json.user_signed_in user_signed_in?
      json.current_user_id  current_user.id
      json.user_email current_user.email
      json.question_user_id @question.user_id

      json.answer_path answer_path(@answer)
      json.accept_answer_path accept_question_answer_path(@question,@answer)

      json.attachments @answer.attachments do |attachment|
        json.id attachment.id
        json.name attachment.file_identifier
        json.url attachment.file.url
      end 

    end
  end
end
