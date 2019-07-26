FactoryBot.define do
  factory :user, aliases: [:sender, :receiver, :friend] do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name  }
    last_name { Faker::Name.last_name }
    password { 'password' }
  end
end
