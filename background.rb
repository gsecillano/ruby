#!/usr/bin/env ruby
$: << File.dirname(__FILE__)
require 'blacklist'

wp_type = 'flickr'
#wp_type = 'xkcd'
load "#{wp_type}_wallpaper.rb"
File.open("/tmp/current_url", "w") do |f|
  f.write $url
end

if blacklist = (ARGV[0] == 'blacklist')
  Blacklist.blacklist!
end

