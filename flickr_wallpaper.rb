#!/usr/bin/env ruby
# Chooses a photo from the current interesting
# photo and set it as the background image on
# your first KDE desktop.

require 'rubygems'
require 'flickraw'
require 'RMagick'
require File.join(File.dirname(__FILE__), 'blacklist')

FlickRaw.api_key = 'ff884c72ba55fbf1299d7c840dfe6ec0'
FlickRaw.shared_secret ='05efc23236fe439f'
FlickRaw.proxy = ENV['http_proxy']

while true do
  #list = flickr.interestingness.getList

  tags = "modern,architecture"
  #tags = "nasa"
  #tags = "landscapes"
  #tags = "flickrstruereflection1"
  #tags = "mexico,tourism"
  #tags = "travel"
  #tags = "europe"
  #tags = "matrix"
  #tags = "australia"
  #tags = "sochi 2014"
  list = flickr.photos.search :tags => tags, :sort => 'interestingness-desc', :per_page => 10, :page => rand(100)

  photo = list[rand(list.size)]
  sizes = flickr.photos.getSizes(:photo_id => photo.id)
  choice = sizes.find {|s| s.label == 'Original' }
  choice = sizes.find {|s| s.label == 'Large' } unless choice

  next unless choice

  $url = choice.source
  break unless Blacklist.blacklisted? $url
end
wp_folder = "#{ENV['HOME']}/Pictures/backgrounds/wp"
list = Dir["#{wp_folder}/*"]
if list.size > 2
  File.unlink(list.first)
end
file = "#{wp_folder}/#{Time.now.to_i}.png"
full_path = File.join(Dir.pwd, file)

background = "#{ENV['HOME']}/Pictures/backgrounds/Leather-Hole-sPlain.png"
wp = Magick::ImageList.new(background)

screen_width = 1440
screen_height = 900
overlay_scale = 0.3
offset = 30
flickr_image = Magick::ImageList.new $url
resized = flickr_image.resize_to_fit(screen_width,screen_height)
wp.composite!(resized, (screen_width - resized.columns)/2, (screen_height - resized.rows)/2, Magick::AtopCompositeOp)
katkam_image = Magick::ImageList.new "http://katkam.ca/pic.aspx" 
scaled = katkam_image.scale(overlay_scale)
wp.composite!(scaled, screen_width - scaled.columns - offset, screen_height - scaled.rows - offset, Magick::AtopCompositeOp)
wp.write file


