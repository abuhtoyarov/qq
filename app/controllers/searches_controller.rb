class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    case params[:conditions]
      when 'Question'
        @search = Question.search params[:search]
      when 'Answer'
    	@search = Answer.search params[:search]
      when 'Comment'
    	@search = Comment.search params[:search]
      when 'User'
    	@search = User.search params[:search]
    
      when 'All'
    	@search = ThinkingSphinx.search params[:search]
    end
    authorize! :index, @search
  end

end

