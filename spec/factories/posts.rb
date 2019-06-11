FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph_by_chars(180) }
    association :user, factory: :user
  end
end
