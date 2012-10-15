#!/usr/bin/env ruby
# Chooses a photo from the current interesting
# photo and set it as the background image on
# your first KDE desktop.

require 'rubygems'
require 'flickraw'
require 'RMagick'

DESKTOP=1

FlickRaw.api_key = 'ff884c72ba55fbf1299d7c840dfe6ec0'
FlickRaw.shared_secret ='05efc23236fe439f'
FlickRaw.proxy = ENV['http_proxy']

#list = flickr.interestingness.getList
#tags = "modern,architecture"
#tags = "nasa"
#tags = "landscapes"
#tags = "flickrstruereflection1"
#tags = "mexico,tourism"
#tags = "travel"
#tags = "europe"
#tags = "matrix"
tags = "australia"

list = flickr.photos.search :tags => tags, :sort => 'interestingness-desc', :per_page => 10, :page => rand(100)
photo = list[rand(list.size)]
sizes = flickr.photos.getSizes(:photo_id => photo.id)
choice = sizes.find {|s| s.label == 'Original' }
choice = sizes.find {|s| s.label == 'Large' } unless choice

suffix_file = "/tmp/flickr_wallpaper"
unless File.exists? suffix_file
  suffix = 0
else
  suffix = 1
end
url = choice.source
file = "#{ENV['HOME']}/Pictures/backgrounds/flickr/flickr_image#{suffix}"
full_path = File.join(Dir.pwd, file)

background = "#{ENV['HOME']}/Pictures/backgrounds/Leather-Hole-sPlain.png"
wp = Magick::ImageList.new(background)

screen_width = 1280
screen_height = 1024
overlay_scale = 0.3
offset = 30
flickr_image = Magick::ImageList.new choice.source
resized = flickr_image.resize_to_fit(screen_width,screen_height)
wp.composite!(resized, (screen_width - resized.columns)/2, (screen_height - resized.rows)/2, Magick::AtopCompositeOp)
katkam_image = Magick::ImageList.new "http://katkam.ca/pic.aspx" 
scaled = katkam_image.scale(overlay_scale)
wp.composite!(scaled, screen_width - scaled.columns - offset, screen_height - scaled.rows - offset, Magick::AtopCompositeOp)
wp.write file

if suffix == 0
  File.open(suffix_file, "w") do |f|
    f.write 0
  end
else
  File.delete(suffix_file)
end

#open url do |remote|
  #open(file, 'wb') { |local| local << remote.read }
#end

