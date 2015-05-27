class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_comment, except: [:create]
  before_action :authors, except: [:create]
  before_action :load_commentable, only: [:create]

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment=@commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@comment.destroy)
  end

  def update
    @comment.update(comment_params)
    respond_with @comment
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

