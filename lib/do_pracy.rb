require 'gosu'
require 'nokogiri'
require 'tzinfo'
require 'optparse'

Dir['./lib/**/*.rb'].each do |dep|
	require dep
end