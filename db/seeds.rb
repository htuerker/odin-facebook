# Users
50.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.unique.email
  password = "password"
  User.create!(first_name: first_name, last_name: last_name, email: email, password: password)
end

User.first.friends << User.offset(1).take(10)