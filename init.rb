def dev
  require "dev"
end

def test
  require "test"
end

def ort
    ENV['WHOHAR_HOME'] = "#{ENV['DEVBASE']}/Oxygen/OxytenRailsTests"
    require "dev"
end

def kona
    ENV['WHOHAR_HOME'] = "#{ENV['DEVBASE']}/Whohar/whohar"
    require "dev"
end

def whohar_home= home
    ENV['WHOHAR_HOME'] = home
end

def cm
  whohar_home = "#{ENV['DEVBASE']}/Oxygen/configmanager"
  require "dev"
end
