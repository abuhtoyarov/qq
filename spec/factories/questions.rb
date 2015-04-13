FactoryGirl.define do

  factory :question do
    user
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

  factory :question_with_attach, class: "Question" do
    user
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    after(:create) do |question, eval|
      create(:attachment, attachable: question)
    end
  end

end
