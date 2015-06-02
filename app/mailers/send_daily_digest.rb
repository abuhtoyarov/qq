class SendDailyDigest < ApplicationMailer

  def digest(user)
    @question = Question.last_day
    mail to: user.email
  end

end
