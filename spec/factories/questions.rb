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
    transient do
      count_attachments 2
    end

    after(:create) do |question, eval|
      create_list(:attachment, eval.count_attachments, attachable: question)
    end
  end

end
