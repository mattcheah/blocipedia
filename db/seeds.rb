# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
	User.create!(email: "#{Faker::Name.unique.first_name}@blocipedia.com", password: "password", password_confirmation: "password")
end
#Create 5 wikis

10.times do 
	Wiki.create!(title: Faker::StarWars.vehicle + " on " + Faker::StarWars.planet, body: '"'+Faker::StarWars.quote+'" - ' + Faker::StarWars.character, private: false, user: User.first)
end

puts "#{Wiki.all.length} Wikis generated"
puts "#{User.all.length} Users generated"
