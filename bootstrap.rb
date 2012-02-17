#!/usr/bin/ruby

def command?(command)
    system("which #{ command} > /dev/null 2>&1")
end

if !command?("hg") 
then
    puts "You need HG to run this script.\nSee http://"
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

cmd = "sudo gem install gem/xcode-deployer.gem"
puts "Installing custom gem:\n#{cmd}"
if system cmd then
    puts "\n\nBase tools are installed, now checking out required projects."
else
    puts "\n\nBase tools not installed, aborting."
    exit 1
end
puts "Cloning KraCommons."
cmd = "hg clone https://bitbucket.org/krakas/kracommons \"../KraCommons\""
puts cmd
if system cmd then
    puts "\n\nKraCommons successfully cloned."
else
    puts "\n\nKraCommons failed to clone."
end

puts "\n\nCloning HTTPServe."
cmd = "hg clone https://bitbucket.org/krakas/httpserve \"../HTTPServe\""
puts cmd
if system cmd then
    puts "\n\nHTTPServe successfully cloned."
    else
    puts "\n\nHTTPServe failed to clone."
end

puts "Cloning MediaManagement Common Library."
cmd = "hg clone https://bitbucket.org/krakas/mediamanagement-common \"../MediaManagementCommon\""
puts cmd
if system cmd then
    puts "\n\nHTTPServe successfully cloned."
    else
    puts "\n\nHTTPServe failed to clone."
end

puts "\n\nCloning CLIServer."
cmd = "hg clone https://bitbucket.org/krakas/itunes-server \"../CLIServer\""
puts cmd
if system cmd then
    puts "\n\nCLIServer successfully cloned."
    else
    puts "\n\nCLIServer failed to clone."
end

puts "Now building..."
puts "KraCommons"
initialWorkingDirectory = Dir.getwd
Dir.chdir "../KraCommons"
cmd = "rake clean build deploy"
built = true

built &= system cmd
if !built then
    puts "Build and deploy of KraCommons failed. Proceeding."
end

puts "\n\nHTTPServe"
Dir.chdir "../HTTPServe"
cmd = "rake clean build deploy"
built &= system cmd
if !built then
    puts "Build and deploy of KraCommons failed. Proceeding."
end

puts "\n\nMedia Management Common"
Dir.chdir "../MediaManagementCommon"
cmd = "rake clean build deploy"
built &= system cmd
if !built then
    puts "Build and deploy of KraCommons failed. Proceeding."
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