#!/usr/bin/env ruby
# Chooses a photo from the current interesting
# photo and set it as the background image on
# your first KDE desktop.

require 'rubygems'
require 'RMagick'
require 'open-uri'
require File.join(File.dirname(__FILE__), 'blacklist')

#url = open("http://dynamic.xkcd.com/random/comic") { |remote| m=remote.read.match(/\<img *src=['"]([^'"]*)['"]/); m[1] }
#url = open("http://dynamic.xkcd.com/random/comic") { |remote| m=remote.read.match(/Image URL[^:]*: (.*)/); m[1] }
while true do
  page = open("http://dynamic.xkcd.com/random/comic") { |remote| remote.read }
  $url = page.match(/Image URL[^:]*: (.*)/)[1] 
  break Blacklist.blacklisted? $url
end
title = page.match(/<div id="ctitle">(.*)<\/div>/)[1] 
caption = page.match(/<img src=.*title="([^"]*)"/)[1] 
caption.gsub! /&#39;/, %/'/
caption.gsub! /&quot;/, %/"/

file = "#{ENV['HOME']}/Pictures/backgrounds/xkcd/xkcd_image"
full_path = File.join(Dir.pwd, file)

background = "#{ENV['HOME']}/Pictures/backgrounds/Leather-Hole-sPlain.png"
wp = Magick::ImageList.new(background)


screen_width = 1250
#screen_height = 1024
screen_height = 850
overlay_scale = 0.3
offset = 30
xkcd_image = Magick::ImageList.new $url
resized = xkcd_image.resize_to_fit(screen_width,screen_height)
#resized[:caption] = "#{title}\n#{caption}"
#resized = resized.polaroid(0) {
  #self.border_color = 'white'
#}
resized.border!(5,5, 'white')
#resized = resized.blur_image

wp.composite!(resized, (screen_width - resized.columns)/2 + 15, (screen_height - resized.rows)/2 + 30, Magick::AtopCompositeOp)
#wp.composite!(resized, (screen_width - resized.columns)/2, (screen_height - resized.rows)/2, Magick::AtopCompositeOp)

writer = Magick::Draw.new
writer.annotate(wp, 0, 0, 10, screen_height+65, title) do
    self.font_family = 'Helvetica'
    self.fill = 'white'
    self.stroke = 'transparent'
    self.pointsize = 32
    self.font_weight = Magick::BoldWeight
    self.gravity = Magick::NorthGravity
end

captions = caption.split
lines = []
if captions.size > 15
  lines << captions[0..captions.size/2].join(' ')
  lines << captions[captions.size/2+1..captions.size].join(' ')
else
  lines << caption
end
lines.each_with_index do |l, i| 
  writer.annotate(wp, 0, 0, 10, screen_height+100+(i*20), l) do
      self.font_family = 'Helvetica'
      self.fill = 'white'
      self.stroke = 'transparent'
      self.pointsize = 15 
      #self.font_weight = Magick::BoldWeight
      self.gravity = Magick::NorthGravity
  end
end

wp.write file
