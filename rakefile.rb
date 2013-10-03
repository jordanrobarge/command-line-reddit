require 'rubygems'
require 'bundler/setup' # Releasy requires require that your application uses bundler.
require 'releasy'

#<<<
Releasy::Project.new do
  name "Command Line Reddit"
  version "1.0"
  verbose # Can be removed if you don't want to see all build messages.

  executable "bin/command.line.reddit.rb"
  files "lib/**/*.rb", "config/**/*.yml", "media/**/*.*"
  exposed_files "README.html", "LICENSE.txt"
  add_link "http://my_application.github.com", "My Application website"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  add_build :osx_app do
    url "github.com/loganhasson/command-line-reddit"
    wrapper "wrappers/gosu-mac-wrapper-0.7.47.tar.gz" # Assuming this is where you downloaded this file.
    icon "media/icon.icns"
    add_package :tar_gz
  end

  add_deploy :local # Only deploy locally.
end
#>>>