class SendSubs < ApplicationMailer

  def send_subs_answer(subscriber)
    email = subscriber.user.email
    mail to: email,
         subject: 'New answer to subscribed question',
         body: 'body'
  end

end
