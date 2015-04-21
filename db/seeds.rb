# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Video.create(title: "Southpark", description: "Colorado town of crazy kids",
              small_cover_url: "south_park.jpg", large_cover_url: "south_park.jpg")
Video.create(title: "Futurama", description: "Fry discovers the future",
              small_cover_url: "futurama.jpg", large_cover_url: "futurama.jpg")
Video.create(title: "Monk", description: "Crazy unorthadox detective gets results",
              small_cover_url: "monk.jpg", large_cover_url: "monk_large.jpg")
