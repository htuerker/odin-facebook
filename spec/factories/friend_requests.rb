FactoryBot.define do
  factory :friend_request do
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
