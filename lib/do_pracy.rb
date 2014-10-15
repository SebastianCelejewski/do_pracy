require 'rubygems'
require 'bundler'
Bundler.require(:default)

Dir['./lib/**/*.rb'].each do |dep|
	require dep
end