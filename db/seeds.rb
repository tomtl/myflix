# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies = Category.create!(name: "Comedies")
action = Category.create!(name: "Action")
dramas = Category.create!(name: "Dramas")
# southpark = Video.create!(title: "Southpark",
#                           description: "Colorado town of crazy kids",
#                           category: comedies,
#                           small_cover_url: "/tmp/south_park.jpg",
#                           large_cover_url: "/tmp/south_park.jpg")
# futurama = Video.create!(title: "Futurama",
#                         description: "Fry discovers the future",
#                         category: action,
#                         small_cover_url: "/tmp/futurama.jpg",
#                         large_cover_url: "/tmp/futurama.jpg")
# monk = Video.create!(title: "Monk",
#                     description: "Crazy unorthadox detective gets results",
#                     category: dramas,
#                     small_cover_url: "/tmp/monk.jpg",
#                     large_cover_url: "/tmp/monk_large.jpg")
# family_guy = Video.create!(title: "Family Guy",
#                           description: "Sick, twisted, and politically incorrect, the animated series features the adventures of the Griffin family",
#                           small_cover_url: "/tmp/family_guy.jpg",
#                           large_cover_url: "/tmp/family_guy.jpg",
#                           category: comedies)
# Video.create!(title: "Southpark",
#               description: "Colorado town of crazy kids",
#               category: comedies,
#               small_cover_url: "/tmp/south_park.jpg",
#               large_cover_url: "/tmp/south_park.jpg")
# Video.create!(title: "Futurama",
#               description: "Fry discovers the future",
#               category: action,
#               small_cover_url: "/tmp/futurama.jpg",
#               large_cover_url: "/tmp/futurama.jpg")
# Video.create!(title: "Monk",
#               description: "Crazy unorthadox detective gets results",
#               category: dramas,
#               small_cover_url: "/tmp/monk.jpg",
#               large_cover_url: "/tmp/monk_large.jpg")
# Video.create!(title: "Family Guy",
#               description: "Sick, twisted, and politically incorrect, the animated series features the adventures of the Griffin family",
#               small_cover_url: "/tmp/family_guy.jpg",
#               large_cover_url: "/tmp/family_guy.jpg",
#               category: comedies)
# Video.create!(title: "Family Guy",
#               description: "Sick, twisted, and politically incorrect, the animated series features the adventures of the Griffin family",
#               small_cover_url: "/tmp/family_guy.jpg",
#               large_cover_url: "/tmp/family_guy.jpg",
#               category: comedies)
# Video.create!(title: "Southpark",
#               description: "Colorado town of crazy kids",
#               category: comedies,
#               small_cover_url: "/tmp/south_park.jpg",
#               large_cover_url: "/tmp/south_park.jpg")
# Video.create!(title: "Family Guy",
#               description: "Sick, twisted, and politically incorrect, the animated series features the adventures of the Griffin family",
#               small_cover_url: "/tmp/family_guy.jpg",
#               large_cover_url: "/tmp/family_guy.jpg",
#               category: comedies)

tom = User.create!(full_name: "Tom Test", password: "password", email: "tom@example.com", admin: true)

# Review.create!(user: tom, video: monk, rating: 5, content: "This is a really good movie! My review is very positive about it. Here is more to be read.")
# Review.create!(user: tom, video: monk, rating: 2, content: "This is a OK movie times two! My review is mediocre about it. Here is more to be read.")
