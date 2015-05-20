module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def liked_by(user)
    unless Vote.exists?(:user_id => user)
      votes.create(user: user, rating: 1)
    end
  end 
  
  def disliked_by(user)
    unless Vote.exists?(:user_id => user)
      votes.create(user: user, rating: -1)
    end
  end

  def rating
    votes.sum :rating
  end

  def unvoted_by(user)
    votes.where(user_id: user.id).delete_all
  end
end
