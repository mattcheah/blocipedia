# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(email: "User1@blocipedia.com", password: "password", password_confirmation: "password")

#Create 5 wikis
i = 1
5.times do 
	Wiki.create!(title: "Wiki ##{i}", body: "This is the body for Wiki ##{i}, and this has a lot of information.", private: false, user: User.first)
	i += 1
end

puts "#{Wiki.all.length} Wikis generated"
