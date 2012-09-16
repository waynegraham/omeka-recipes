require "capistrano"
require "capistrano/cli"
require "helpers"
require "omeka-recipes/version"

Dir.glob(File.join(File.dirname(__FILE__), 'omeka-recipes/*.rb')).sort.each { |f| load f }
