class Question < ActiveRecord::Base

  include Votable

  validates :title, :body, presence: true
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable , dependent: :destroy
  belongs_to :user
  has_many :subscribers

  accepts_nested_attributes_for :attachments, :allow_destroy => true

  scope :last_day, -> { where(created_at: (Time.now.utc - 1.day).all_day) }

  after_create :subscribe_own_question

  private

  def subscribe_own_question
    Subscriber.create(user: user, question: self)
  end

end
