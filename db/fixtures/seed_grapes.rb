puts "Can I do this?"
open("#{Rails.root}/db/fixtures/grapes.csv") do |grapefile|
  grapefile.read.each_line do |grape|
    name, color = grape.chomp.split(",")
    puts name
  end
end

