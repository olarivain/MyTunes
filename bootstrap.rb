#!/usr/bin/ruby

def command?(command)
    system("which #{ command} > /dev/null 2>&1")
end

if !command?("git") 
    then
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

begin
    puts "\n\nDo you want to Rake gem? In doubt, you must. (y/n)"
    answer = gets.chomp
end while (!("y".eql? answer) && !("n".eql? answer))

if "y".eql? answer then
    cmd = "sudo gem install rake"
    puts "Installing rake:\n#{cmd}"
    if system cmd then
        puts "\n\nRake successfully installed. Proceeding"
        else
        puts "\n\nRake failed to install. Proceeding."
    end
end

cmd = "sudo gem install gem/raven-xcode-0.0.8.gem"
puts "Installing custom gem:\n#{cmd}"
if system cmd then
    puts "\n\nBase tools are installed, now checking out required projects."
    else
    puts "\n\nBase tools not installed, aborting."
    exit 1
end
puts "Cloning KraCommons."
cmd = "git clone git://github.com/krakas/KraCommons.git \"../KraCommons\""
puts cmd
if system cmd then
    puts "\n\nKraCommons successfully cloned."
    else
    puts "\n\nKraCommons failed to clone."
end

puts "\n\nCloning YARES."
cmd = "git clone git://github.com/krakas/YARES.git \"../YARES\""
puts cmd
if system cmd then
    puts "\n\nYARES successfully cloned."
    else
    puts "\n\nYARES failed to clone."
end

puts "Cloning MediaManagement Common Library."
cmd = "git clone git://github.com/krakas/MediaManagementCommon.git \"../MediaManagementCommon\""
puts cmd
if system cmd then
    puts "\n\nMediaManagement Common successfully cloned."
    else
    puts "\n\nMediaManagement Common failed to clone."
end

puts "\n\nCloning iTunesServer."
cmd = "git clone git://github.com/krakas/iTunesServer.git \"../iTunesServer\""
puts cmd
if system cmd then
    puts "\n\niTunesServer successfully cloned."
    else
    puts "\n\niTunesServer failed to clone."
end

puts "Now building..."
puts "KraCommons"
initialWorkingDirectory = Dir.getwd
Dir.chdir "../KraCommons"
cmd = "rake clean build install"
built = true

built &= system cmd
if !built then
    puts "Build and install of KraCommons failed. Proceeding."
end

puts "\n\nYARES"
Dir.chdir "../YARES"
cmd = "rake clean build install"
built &= system cmd
if !built then
    puts "Build and install of YARES failed. Proceeding."
end

puts "\n\nMedia Management Common"
Dir.chdir "../MediaManagementCommon"
cmd = "rake clean build install"
built &= system cmd
if !built then
    puts "Build and install of Media Management Common failed. Proceeding."
end

if built then
    puts "Y'all setup. Opening MediaManagement workspace"
    Dir.chdir initialWorkingDirectory
    cmd = "open ./MediaManagementWorkspace.xcworkspace"
    puts cmd
    system cmd
    else
    puts "Looks like the build is broken. Sorry about that."
end