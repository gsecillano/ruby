def dev
  require "dev"
end

def test
  require "test"
end

def ort
    ENV['WHOHAR_HOME'] = 'd:/projects/dev/Oxygen/OxygenRailsTests'
    require "dev"
end
