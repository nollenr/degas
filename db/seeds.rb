# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#  puts "Loading grapes..."

#  Grape.delete_all
#  open("#{Rails.root}/db/redwinegrapes.csv") do |grapefile|
#    grapefile.read.each_line do |grapeline|
#      grape, color = grapeline.chomp.split(",")
#      puts "Creating new grape: #{grape}"
#      Grape.create!(name: grape, color: color)
#    end
#  end

#NOTE:  Must add 
#  bottle.rb model
#  attr_accessible :bottle_id, :grape_id
#
#  remove ":grape_id" when load is complete

puts "Loading bottles..."

Bottle.delete_all
open("#{Rails.root}/db/bottles.csv") do |bottlefile|
  bottlefile.read.each_line do |bottleline|
    v_bottle_id, v_grape_id = bottleline.chomp.split(",")
    puts "Creaing new bottle... bottle_id: #{v_bottle_id} grape_id: #{v_grape_id}"
    Bottle.create!(bottle_id: v_bottle_id, grape_id: v_grape_id)
  end
end

