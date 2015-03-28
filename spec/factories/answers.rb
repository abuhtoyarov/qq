FactoryGirl.define do

  sequence :answer_body do |n|
    "Answer - #{n}"
  end

  factory :answer do
    body "My Text"
    question nil
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end

end
