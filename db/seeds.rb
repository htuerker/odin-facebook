# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create(first_name: "Burhan", last_name: "Tuerker", email: "burhan@burhan.com", password: "password")
p = Post.create(user: u, content: "New post content")
c = Comment.create(user: u, post: p, content: "New comment content")

