class Answer < ActiveRecord::Base

  include Votable

  validates :body, presence: true
  belongs_to :question
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable , dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, :allow_destroy => true

  after_create :notice_subscriber_question


  private

  def notice_subscriber_question
    AnswerNotificationsJob.perform_later(self.id)
  end

end


