# Generate Users
(1..15).each do |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "user#{i}@mail.com"
  password = "password"
  User.create!(first_name: first_name, last_name: last_name, email: email, password: password)
end

# Generate friendship among user.first and next 5 users
first_user = User.first
users = User.offset(1).take(5)

first_user.friends << users
users.each do |user|
  user.friends << first_user
end

## Generate Posts
User.take(5).each do |user|
  5.times do
    user.posts.create!(content: Faker::Lorem.paragraph_by_chars(180))
  end
end

# Generate Comments
posts = Post.take(5)
User.take(5).each do |user|
  posts.each do |post|
    post.comments.create!(user: user, content: Faker::Lorem.paragraph_by_chars(150))
  end
end

# Generate Likes
posts = Post.take(5)
User.take(5).each do |user|
  posts.each do |post|
    post.likes.create!(user: user)
  end
end


