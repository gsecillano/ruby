#!/usr/bin/env ruby
# Chooses a photo from the current interesting
# photo and set it as the background image on
# your first KDE desktop.

require 'fileutils'
require 'rubygems'
require 'flickraw'
require 'RMagick'
require File.join(File.dirname(__FILE__), 'blacklist')

FlickRaw.api_key = 'ff884c72ba55fbf1299d7c840dfe6ec0'
FlickRaw.shared_secret ='05efc23236fe439f'
FlickRaw.proxy = ENV['http_proxy']

while true do
  #list = flickr.interestingness.getList

  #tags = "modern,architecture"
  #tags = "nasa"
  tags = "landscapes"
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

bgdir = "#{ENV['HOME']}/Pictures/backgrounds"
fname = if File.mtime("#{bgdir}/bg_image") < File.mtime("#{bgdir}/bg_image1") 
          "bg_image" 
        else
          "bg_image1"
        end
file = "#{ENV['HOME']}/Pictures/backgrounds/#{fname}"
full_path = File.join(Dir.pwd, file)

#background = "#{ENV['HOME']}/Pictures/backgrounds/Leather-Hole-sPlain.png"
background = "#{ENV['HOME']}/Pictures/backgrounds/Leather-Hole-sPlain-1920x1200.png"

#screen_width = 1920
#screen_height = 1200
#screen_width = 1280
#screen_height = 900
screen_width = 1280
screen_height = 1024
overlay_scale = 0.4
offset = 30
wp = Magick::ImageList.new(background).resize_to_fill(screen_width,screen_height)
flickr_image = Magick::ImageList.new $url
resized = flickr_image.resize_to_fill(screen_width,screen_height)
wp.composite!(resized, (screen_width - resized.columns)/2, (screen_height - resized.rows)/2, Magick::AtopCompositeOp)
cam = "http://webcam.westinbayshore.com/the-westin-bayshore-vancouver.jpg"
#cam = "http://cam.westinbayshore.com/cam_img/pic.jpg"
#cam = "http://cam.westinbayshore.com/cam_img/view_live1.jpg"
#cam = "http://katkam.ca/pic.aspx" 
image = Magick::ImageList.new cam
scaled = image.scale(overlay_scale)
wp.composite!(scaled, screen_width - scaled.columns - offset, screen_height - scaled.rows - offset, Magick::AtopCompositeOp)
wp.write file


