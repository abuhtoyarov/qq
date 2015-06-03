class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user= user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :update, :all, user: user
    can :destroy,:all, user: user
    can [:like, :dislike], Votable do |votable|
      votable.user != user && votable.votes.where(user: user).empty?
    end
    can :unvote, Votable do |votable|
      votable.votes.where(user: user).exists?
    end
    can :accept, Answer, :question => {:user => user}
    can :create, Subscriber do |subscriber|
      !@user.subscribers.where(question_id:subscriber.question).present?
    end
    can :destroy, Subscriber, user_id: user
    can :create, [Question, Answer, Comment]
  end
end
