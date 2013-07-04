require 'rubygems'
require 'xcodebuilder'

builder = XcodeBuilder::XcodeBuilder.new do |config|
  # basic workspace config
  config.build_dir = :derived
  config.workspace_file_path = "MyTunes.xcworkspace"
  config.scheme = "MyTunes"
  config.configuration = "Release" 
  config.app_name = "MyTunes"
  config.sdk = "iphoneos"
  config.info_plist = "./MyTunes/SupportingFiles/MyTunes-Info.plist"
  config.skip_dsym = true
  config.skip_clean = false
  config.verbose = false
  config.increment_plist_version = true
  config.tag_vcs = true
  # jesus fucking christ apple, really?!?
  config.signing_identity = "iPhone Developer: Olivier Larivain"
  
  # testflight app is used for deployment
  config.deploy_using(:testflight) do |testFlight|
  	testFlight.api_token = "0cafa432a85d87075459c4ce599bbb37_MzUyMTQ4MjAxMi0wMy0xMSAxODoyMDo1OS4yMTg2NjA"
  	testFlight.team_token = "885726797eb57d89b4756e984ea66202_NzAzNjIyMDEyLTAzLTExIDE5OjE1OjQyLjY2MTczMQ"

  	testFlight.distribution_lists = ["Internal"]
  	testFlight.generate_release_notes do
  	    "Nightly build"
  	end
  end

  # tag and release with git
  config.release_using(:git) do |git|
    git.branch = "master"
  end
end

task :clean do
  # dump temp build folder
  FileUtils.rm_rf "./build"
  FileUtils.rm_rf "./pkg"

  # and cocoa pods artifacts
  FileUtils.rm_rf builder.configuration.workspace_file_path
  FileUtils.rm_rf "Podfile.lock"
end

# pod requires a full clean and runs pod install
task :pod => :clean do
  system "pod install"
end

task :package do
  builder.package
end

task :release => :pod do
  builder.release
end