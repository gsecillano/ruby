module Blacklist
  def self.blacklisted? url
    !(File.read("#{ENV['HOME']}/.blacklist").match(url)).nil?
  end
  def self.blacklist!
    File.open("#{ENV['HOME']}/.blacklist", "a") do |f|
      f.puts(File.read("/tmp/current_url"))
    end
    wp_file = "/home/george/utility-scripts/wp.xml"
    system("touch #{wp_file}")
    system("gsettings set org.gnome.desktop.background picture-uri file://#{wp_file}") 
  end
end

