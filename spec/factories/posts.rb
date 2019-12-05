FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph_by_chars(number: 180) }
    association :user, factory: :user
  end
end
