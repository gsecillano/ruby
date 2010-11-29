$LOAD_PATH << File.expand_path(".")
conf.prompt_i = "dev>> "
ENV['RAILS_ENV'] = 'development'
Dir.chdir ENV['WHOHAR_HOME'] || 'd:/projects/dev/Constellation/whohar'
require "irb/completion"
require "config/environment"
require "console_app"
require "console_with_helpers"
require "bypass"
