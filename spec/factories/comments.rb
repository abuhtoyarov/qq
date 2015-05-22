FactoryGirl.define do
  factory :comment do
    sequence(:body) {|n| "Answer ##{n}"}
    user
  end

end
