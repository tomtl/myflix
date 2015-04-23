# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "Comedy")
Category.create(name: "Action")
Category.create(name: "Drama")
Video.create(title: "Southpark", description: "Colorado town of crazy kids", category: Category.find_by(name: "Comedy"),
              small_cover_url: "south_park.jpg", large_cover_url: "south_park.jpg")
Video.create(title: "Futurama", description: "Fry discovers the future", category: Category.find_by(name: "Action"),
              small_cover_url: "futurama.jpg", large_cover_url: "futurama.jpg")
Video.create(title: "Monk", description: "Crazy unorthadox detective gets results", category: Category.find_by(name: "Drama"),
              small_cover_url: "monk.jpg", large_cover_url: "monk_large.jpg")
Video.create(title: "Family Guy", description: "Sick, twisted, and politically incorrect, the animated series features the adventures of the Griffin family",
            small_cover_url: "family_guy.jpg", large_cover_url: "family_guy.jpg", category: Category.find_by(name: "Comedy"))
