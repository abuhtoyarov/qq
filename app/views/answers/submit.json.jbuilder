json.(@answer, :id, :body, :best, :user_id, :rating)

json.user_signed_in user_signed_in?
json.current_user_id  current_user.id
json.user_email current_user.email
json.question_user_id @question.user_id
json.votes @answer.votes


json.answer_path question_answer_path(@question,@answer)
json.accept_answer_path accept_question_answer_path(@question,@answer)

json.attachments @answer.attachments do |attachment|
  json.id attachment.id
  json.name attachment.file_identifier
  json.url attachment.file.url
end
