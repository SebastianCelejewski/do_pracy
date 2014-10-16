require 'gosu'
require 'nokogiri'
require 'tzinfo'

Dir['./lib/**/*.rb'].each do |dep|
	require dep
end