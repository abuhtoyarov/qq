class Answer < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  before_update :replace_best_answer

  protected
    def replace_best_answer
      if self.best
        Answer.where(question_id:self.question_id).each do |answer|
          answer.update_column(:best,nil)
        end
      end
    end
end


