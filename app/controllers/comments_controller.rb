class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create

    @commentable = params[:commentable].classify.constantize.find(params[(params[:commentable].singularize + '_id')])
    @comment = @commentable.comments.new(comment_params)
    @comment.save

  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end

