require 'rails_helper'

RSpec.describe AnswerNotificationsJob, type: :job do


  let!(:answer) { create(:answer)}
  let!(:subscriber) { create(:subscriber, question:answer.question) }

  before{ActionMailer::Base.deliveries = []}

  it 'send notice' do
    AnswerNotificationsJob.perform_later(answer.id)

    expect(ActionMailer::Base.deliveries.count).to eq 2

  end

end
