#app_version.rake
desc "Create an APPVERISON global variable for the rails app."
task :generate_version do
  # %x runs a system command
  appversion = %x[git describe --long --abbrev=10 --tags].chomp
  puts "Application Version: #{appversion}"  
  aFile =  File.new("config/initializers/app_verion.rb","w")
  aFile.syswrite("# This file (config/initializers/app_version.rb) created by rake generate_globals (lib/tasks/genereate_globals.rake)\n")
  aFile.syswrite("# Created : " + Time.now.to_s + "\n")
  aFile.syswrite("APPVERSION=\"#{appversion}\"")
  aFile.close
end

task :generate_globals => :generate_version do
  puts "Generating Global Varilable Initializer"
end