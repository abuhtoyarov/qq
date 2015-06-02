class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscribers

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    return authorization.user if authorization

    return nil if auth['info'].try('email').blank?

    email = auth['info']['email']
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user =User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.send_daily_digest
    find_each.each do |user|
      SendDailyDigest.delay.digest(user)
    end
  end

  def subscription_to(question)
    return nil unless question.is_a? Question
    subscribers.find { |es| es.question_id == question.id }
  end

  def subscribed_to?(question)
    return false unless question.is_a? Question
    subscription_to(question).present?
  end

end

