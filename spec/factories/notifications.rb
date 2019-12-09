FactoryBot.define do
  factory :notification do
    for_comment

    trait :for_comment do
      association :subject, factory: :comment
    end

    trait :for_friend_request do
      association :subject, factory: :friend_request
    end

    association :actor, factory: :user
    association :recipient, factory: :user
    read_status { false }
  end
end
