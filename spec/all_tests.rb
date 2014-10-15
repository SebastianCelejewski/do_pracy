require './spec/config.rb'

Dir['./spec/**/*.rb'].each do |dep|
	require dep
end