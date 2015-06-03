class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    case params[:conditions]
      when 'Question'
        @search = Question.search params[:search]
    end
    authorize! :index, @search
  end

end

