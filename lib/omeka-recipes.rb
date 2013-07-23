require "capistrano"
require "capistrano/cli"
require "helpers"

Dir.glob(File.join(File.dirname(__FILE__), 'omeka-recipes/*.rb'), &method(:require))
