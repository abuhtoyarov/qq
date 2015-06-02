class SubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_subscriber, only: :destroy

  respond_to :js

  authorize_resource

  def create
    respond_with(@subscriber = @question.subscribers.create(user: current_user))
  end

  def destroy
    respond_with(@subscriber.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

end
