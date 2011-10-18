#!/usr/bin/ruby
# Chooses a photo from the current interesting
# photo and set it as the background image on
# your first KDE desktop.

require 'rubygems'
require 'flickraw'
require 'open-uri'
DESKTOP=1

FlickRaw.api_key = 'ff884c72ba55fbf1299d7c840dfe6ec0'
FlickRaw.shared_secret ='05efc23236fe439f'

list = flickr.interestingness.getList
photo = list[rand(100)]
sizes = flickr.photos.getSizes(:photo_id => photo.id)
choice = sizes.find {|s| s.label == 'Original' }
choice = sizes.find {|s| s.label == 'Large' } unless choice

url = choice.source
file = "#{ENV['HOME']}/Pictures/backgrounds/flickr/flickr_image"
full_path = File.join(Dir.pwd, file)

open url do |remote|
  open(file, 'wb') { |local| local << remote.read }
end

