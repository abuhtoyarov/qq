class Answer < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :question
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments
end


