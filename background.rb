#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'blacklist')

wp_type = 'flickr'
load "#{ENV['HOME']}/ruby/#{wp_type}_wallpaper.rb"
File.open("/tmp/current_url", "w") do |f|
  f.write $url
end

if blacklist = (ARGV[0] == 'blacklist')
  Blacklist.blacklist!
end

