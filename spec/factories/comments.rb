FactoryGirl.define do
  factory :comment do
    body "MyText"
commentable_type "MyString"
commentable_id 1
user nil
  end

end
