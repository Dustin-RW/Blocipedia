# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'
include Faker

50.times do

  User.create!(
    email: "#{Internet.email}",
    password: "#{Internet.password(8)}"
  )

end

admin = User.create!(
  email: "admin@example.com",
  password: "password",
  role: "admin"
)

premium = User.create!(
  email: "premium@example.com",
  password: "password",
  role: "premium"
)

standard = User.create!(
  email: "standard@example.com",
  password: "password",
  role: "standard"
)

users = User.all

40.times do


  Wiki.create!(
    user: users.sample,
    title: "#{App.name}",
    body: "#{Hipster.paragraph(3, true, 4)}"
  )

end

puts "Seeds Finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
