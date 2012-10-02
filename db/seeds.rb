# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Loading grapes..."

Grape.delete_all
open("#{Rails.root}/db/redwinegrapes.csv") do |grapefile|
  grapefile.read.each_line do |grapeline|
    grape, color = grapeline.chomp.split(",")
    puts "Creating new grape: #{grape}"
    Grape.create!(name: grape, color: color)
  end
end

