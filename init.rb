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
