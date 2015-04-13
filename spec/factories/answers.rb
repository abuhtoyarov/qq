FactoryGirl.define do

  sequence :answer_body do |n|
    "Answer - #{n}"
  end

  factory :answer do
    sequence(:body) {|n| "Answer ##{n}"}
    question
    user
  end

  factory :answer_with_attach, class: "Answer" do
    sequence(:body) {|n| "Answer ##{n}"}
    question
    user
    after(:create) do |answer, eval|
      create(:attachment, attachable: answer)
    end
  end

  factory :invalid_answer, class: "Answer" do
    user
    question
    body nil
  end
end
