#!/usr/bin/env ruby
# Chooses a photo from the current interesting
# photo and set it as the background image on
# your first KDE desktop.

require 'rubygems'
require 'RMagick'
require 'open-uri'
require 'json'
require File.join(File.dirname(__FILE__), 'blacklist')

#url = open("http://dynamic.xkcd.com/random/comic") { |remote| m=remote.read.match(/\<img *src=['"]([^'"]*)['"]/); m[1] }
#url = open("http://dynamic.xkcd.com/random/comic") { |remote| m=remote.read.match(/Image URL[^:]*: (.*)/); m[1] }
while true do
  comic_uri = begin
           open("http://dynamic.xkcd.com/random/comic", :redirect => false) 
         rescue OpenURI::HTTPRedirect => e
           e.uri.to_s
         rescue
           raise
         end
  data = Hash[
    *JSON.parse(open("#{comic_uri}/info.0.json") { |r| r.read }).map do |k,v|
      [k.to_sym, v]
    end.flatten
  ]
  $url = data[:img]
  #page = open("http://dynamic.xkcd.com/random/comic") { |remote| remote.read }
  #$url = page.match(/Image URL[^:]*: (.*)/)[1] 
  break Blacklist.blacklisted? $url
end
#title = page.match(/<div id="ctitle">(.*)<\/div>/)[1] 
#caption = page.match(/<img src=.*title="([^"]*)"/)[1] 
title = data[:safe_title]
caption = data[:alt]
caption.gsub! /&#39;/, %/'/
caption.gsub! /&quot;/, %/"/

wp_folder = "#{ENV['HOME']}/Pictures/backgrounds/wp"
list = Dir["#{wp_folder}/*"]
if list.size > 2
  File.unlink(list.first)
end
file = "#{wp_folder}/#{Time.now.to_i}.png"
full_path = File.join(Dir.pwd, file)

background = "#{ENV['HOME']}/Pictures/backgrounds/Leather-Hole-sPlain.png"
wp = Magick::ImageList.new(background)


#screen_width = 1250
screen_width = 1440
#screen_height = 1024
screen_height = 900
y_offset = 195
overlay_scale = 0.3
offset = 30
xkcd_image = Magick::ImageList.new $url
resized = xkcd_image.resize_to_fit(screen_width - 10,screen_height - y_offset)
#resized[:caption] = "#{title}\n#{caption}"
#resized = resized.polaroid(0) {
  #self.border_color = 'white'
#}
resized.border!(5,5, 'white')
#resized = resized.blur_image

#wp.composite!(resized, (screen_width - resized.columns)/2 + 15, (screen_height - resized.rows)/2 + 30, Magick::AtopCompositeOp)
wp.composite!(resized, (screen_width - resized.columns)/2, (screen_height - resized.rows - 155)/2, Magick::AtopCompositeOp)

writer = Magick::Draw.new
writer.annotate(wp, 0, 0, 10, screen_height-y_offset+70, title) do
    self.font_family = 'Helvetica'
    self.fill = 'white'
    self.stroke = 'transparent'
    self.pointsize = 32
    self.font_weight = Magick::BoldWeight
    self.gravity = Magick::NorthGravity
end

date = Time.parse("#{data[:year]}-#{data[:month]}-#{data[:day]}").strftime("%B %d, %Y")
info = "XKCD ##{data[:num]} #{date}"
writer.annotate(wp, 0, 0, 10, screen_height-y_offset+105, info) do
    self.font_family = 'Helvetica'
    self.fill = '#00AAEE'
    self.stroke = 'transparent'
    self.pointsize = 14
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
  writer.annotate(wp, 0, 0, 10, screen_height-y_offset+125+(i*20), l) do
      self.font_family = 'Helvetica'
      self.fill = 'white'
      self.stroke = 'transparent'
      self.pointsize = 15 
      #self.font_weight = Magick::BoldWeight
      self.gravity = Magick::NorthGravity
  end
end

wp.write file
