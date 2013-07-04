require 'FileUtils'

# attempt to load custom paths for our libraries
custom_path = "./DevPaths.rb"
if File.exists? custom_path then
	custom_paths = eval(File.new(custom_path).read)
	puts "Using custom paths for libraries from #{custom_path}."
else 
	custom_paths = Hash.new
	puts "Released version of libraries will be used. If you wish to use local version, create DevPaths.rb, see DevPaths-sample.rb for an example"

end

# loads local dev version of a pod if found, failing back to released version otherwise
def dev_pod_or_released(name, version, dev_path)
	if dev_path != nil && (File.exists? File.expand_path(dev_path)) then
		pod name, :path => dev_path
		puts "Using #{name} located at #{dev_path}"
	else
		pod name, "~> #{version}"
		puts "Using latest released version of #{name}"
	end
end

puts

platform :ios, "6.0"

dev_pod_or_released("KraCommons", "0.0.1", custom_paths[:KraCommons])
dev_pod_or_released("MediaManagement", "0.0.1", custom_paths[:MediaManagement])
puts

# inhibit_all_warnings!