require 'rubygems'
require 'bundler'
Bundler.require(:default)

Dir['./lib/**/*.rb'].each do |dep|
	puts dep
	require dep
end