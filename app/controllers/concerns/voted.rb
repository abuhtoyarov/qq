module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:like, :dislike, :unvote]
  end

  def like
    @votable.liked_by(current_user)
    render :update_vote
  end

  def dislike
    @votable.disliked_by(current_user)
    render :update_vote
  end

  def unvote
    @votable.unvoted_by(current_user)
    render :update_vote
  end

  private

  def get_votable
    @votable = controller_name.classify.constantize.find(params[:id])
    votable = controller_name.classify.constantize.find(params[:id])
  end

end
