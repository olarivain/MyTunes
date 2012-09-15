Even though this project depends on a fair amount of projects, initial setup is pretty easy, thanks to a bootstrap ruby script.
Just follow these steps:
- git clone https://github.com/olarivain/MediaManagement.git
- cd MediaManagement
- ruby ./bootstrap.rb

The bootstrap script will perform the following:
1) update ruby gem (unless you opt out). This is needed on older version of MacOSX, say Snow Leopard.
2) install my own custom build gem (raven), which is provided in this project
3) checkout needed dependencies (KraCommons, YARES, MediaManagementCommon and iTunesServer)
4) build these dependencies
5) open the convenience Xcode workspace.

If all goes well, you'll be facing an Xcode workspace with all dependencies.
Just fire iTunesServer target to start the server locally and MediaManagement to start the client in the simulator.
Note that the iPhone is still in its very early stages, use the iPad simulator to give the app a test drive.