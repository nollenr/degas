## This file should contain all the record creation needed to seed the database with its default values.
## The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# puts "Loading grapes..."
# Grape.delete_all
# open("#{Rails.root}/db/redwinegrapes.csv") do |grapefile|
#   grapefile.read.each_line do |grapeline|
#     grape, color = grapeline.chomp.split(",")
#     puts "Creating new grape: #{grape}"
#     Grape.create!(name: grape, color: color)
#   end
# end
# open("#{Rails.root}/db/whitewinegrapes.csv") do |grapefile|
#   grapefile.read.each_line do |grapeline|
#     grape, color = grapeline.chomp.split(",")
#     puts "Creating new grape: #{grape}"
#     Grape.create!(name: grape, color: color)
#   end
# end

# puts "Loading wineries"
# Winery.delete_all
# open("#{Rails.root}/db/wineries.csv") do |wineryfile|
#   wineryfile.read.each_line do |wineryline|
#     if !(/^-/ =~ wineryline)
#       v_name, v_loc_line = wineryline.strip.split(/; */)
#       v_country, v_location1, v_location2, v_location3 = v_loc_line.split(/: */)
#       @winery_rec = Winery.create!(name: v_name, country: v_country, location1: v_location1, location2: v_location2, location3: v_location3)
#       puts "id: #{@winery_rec.id}, name: #{@winery_rec.name}, country: #{@winery_rec.country}, loc1: #{@winery_rec.location1}, loc2: #{@winery_rec.location2}, loc3: #{@winery_rec.location3}"
#     elsif (/^- Winery Mailing List URL:/ =~ wineryline)
#       v_url_name, v_winery_url = wineryline.strip.split(/- Winery Mailing List URL: */)
#       @winery_rec.update_attributes(winery_url: v_winery_url)
#       @winery_rec.save
#     elsif (/^- Twitter URL:/ =~ wineryline)
#       v_url_name, v_twitter_url = wineryline.strip.split(/- Twitter URL: */)
#       @winery_rec.update_attributes(twitter_url: v_twitter_url)
#       @winery_rec.save
#     elsif (/^- Facebook URL:/ =~ wineryline)
#        v_url_name, v_facebook_url = wineryline.strip.split(/- Facebook URL: */)
#       @winery_rec.update_attributes(facebook_url: v_facebook_url)
#       @winery_rec.save
#     end
#   end
# end
#

puts "Loading Bottle Types"
  Bottle_type.find_or_create_by_name!("Wine")
  Bottle_type.find_or_create_by_name!("Port")
  Bottle_type.find_or_create_by_name!("Late Harvest")
  Bottle_type.find_or_create_by_name!("Ice Wine")
  Bottle_type.find_or_create_by_name!("Liquor")
  Bottle_type.find_or_create_by_name!("Other")
