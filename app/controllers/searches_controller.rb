class SearchesController < ApplicationController

  def index
    case params[:conditions]
      when 'Question'
        @search = Question.search Riddle::Query.escape(params[:search])
      when 'Answer'
    	  @search = Answer.search Riddle::Query.escape(params[:search])
      when 'Comment'
    	  @search = Comment.search Riddle::Query.escape(params[:search])
      when 'User'
    	  @search = User.search Riddle::Query.escape(params[:search])
      when 'All'
    	  @search = ThinkingSphinx.search Riddle::Query.escape(params[:search])
    end
    authorize! :index, @search
  end
end

