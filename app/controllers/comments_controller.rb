class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_comment, except: [:create]
  before_action :authors, except: [:create]
  before_action :load_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def destroy
    @comment.destroy
  end

  def update
    @comment.update(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def load_commentable
    @commentable = params[:commentable].classify.constantize.find(params[(params[:commentable].singularize + '_id')])
  end

  def authors
    if @comment.user_id != current_user.id
      render status: 403, text: "access denied"
    end
  end
end

