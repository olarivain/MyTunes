#!/usr/bin/ruby

def command?(command)
    system("which #{command} > /dev/null 2>&1")
end

if !command?("git")  then
    puts "You need git to run this script."
    exit 1
end

answer = ""
begin
    puts "Do you want to update your ruby gems? In doubt, you should. (y/n)"
    answer = gets.chomp
end while (!("y".eql? answer) && !("n".eql? answer))

if "y".eql? answer then
    cmd  = "sudo gem update"
    puts "Updating ruby gem:\n#{cmd}"
    if system cmd then
        puts "\n\nRuby gems updated. Proceeding."
    else
        puts "\n\nRuby gems NOT updated. Proceeding."
    end
else
    puts "Skipping ruby gem update."
end

cmd = "sudo gem install gem/raven-xcode-0.0.8.gem"
puts "Installing custom gem:\n#{cmd}"
if system cmd then
    puts "\n\nBase tools are installed, now checking out required projects."
else
    puts "\n\nBase tools not installed, aborting."
    exit 1
end

puts "Setting up raven"
require 'rubygems'
require 'Raven'
Raven::setup

if !File.exists? File.expand_path("~/.raven/config.json")
  puts "Creating default empty raven config in ~/.raven/config.json"
  cmd = "echo '{\"nexusHost\": \"\",\"repository\":{}}' > ~/.raven/config.json"
  system cmd
end

puts "This script will now clone the dependencies from GitHub into sibling folders"
puts "Press enter to continue."
gets

puts "Cloning KraCommons."
cmd = "git clone git://github.com/olarivain/KraCommons.git \"../KraCommons\""
puts cmd
if system cmd then
    puts "\n\nKraCommons successfully cloned."
else
    puts "\n\nKraCommons failed to clone."
end

puts "\n\nCloning YARES."
cmd = "git clone git://github.com/olarivain/YARES.git \"../YARES\""
puts cmd
if system cmd then
    puts "\n\nYARES successfully cloned."
else
    puts "\n\nYARES failed to clone."
end

puts "Cloning MediaManagement Common Library."
cmd = "git clone git://github.com/olarivain/MediaManagementCommon.git \"../MediaManagementCommon\""
puts cmd
if system cmd then
    puts "\n\nMediaManagement Common successfully cloned."
else
    puts "\n\nMediaManagement Common failed to clone."
end

puts "\n\nCloning iTunesServer."
cmd = "git clone git://github.com/olarivain/iTunesServer.git \"../iTunesServer\""
puts cmd
if system cmd then
    puts "\n\niTunesServer successfully cloned."
else
    puts "\n\niTunesServer failed to clone."
end

puts "Now building dependencies..."

puts "KraCommons"
initialWorkingDirectory = Dir.getwd
Dir.chdir "../KraCommons"
cmd = "rake clean build install"
built = true

built &= system cmd
if !built then
    puts "Build and install of KraCommons failed. Proceeding anyway, you never know."
else
    puts "KraCommons successfully built and installed. Proceeding"
end

puts "\n\nYARES"
Dir.chdir "../YARES"
cmd = "rake clean build install"
built &= system cmd
if !built then
    puts "Build and install of YARES failed. Proceeding anyway, you never know."
else
    puts "YARES successfully built and installed. Proceeding"
end

puts "\n\nMedia Management Common"
Dir.chdir "../MediaManagementCommon"
cmd = "rake clean build install"
built &= system cmd
if !built then
    puts "Build and install of Media Management Common failed. Proceeding anyway, you never know."
else
  puts "MediaManagementCommon successfully built and installed. Proceeding"
end

if built then
    puts "Y'all setup!"
else
    puts "Looks like the build is broken. Sorry about that."
end

puts "\n\nOpening MediaManagement workspace"
Dir.chdir initialWorkingDirectory
cmd = "open ./MediaManagementWorkspace.xcworkspace"
puts cmd
system cmd