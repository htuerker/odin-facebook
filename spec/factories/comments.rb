FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph_by_chars(number: 150) }
    association :user, factory: :user
    association :post, factory: :post
  end
end
