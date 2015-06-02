require 'rails_helper'

RSpec.describe AnswerNotificationsJob, type: :job do


  let!(:user) { create(:user) }
  let!(:question) { create(:question, user:user) }
  let(:answer) { create(:answer, question:question)}
  let!(:subscriber) { create(:subscriber, question:answer.question)}


  it 'send notice' do
    expect(AnswerNotificationsJob).to receive(:perform_later).with(answer.id).and_call_original
    AnswerNotificationsJob.perform_later(answer.id)
  end

end
