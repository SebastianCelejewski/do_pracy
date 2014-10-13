require 'gosu'

module DoPracy

	class Images

		def initialize (window)
			@data = Hash.new
			@data[:pedestrian] = load_image window, "pedestrian.png"
			@data[:bicycle] = load_image window, "bicycle.png"
			@data[:car] = load_image window, "car.png"
			@data[:train] = load_image window, "skm.png"
			@data[:bus] = load_image window, "bus.png"
			@data[:unknown] = load_image window, "unknown.png"
		end

		def load_image (window, name)
			puts "Loading image #{name}"
			Gosu::Image.new(window, "./images/icons/#{name}", false)		
		end

		def [] name
			puts "Getting image for #{name}"
			return @data[:unknown] if name == nil
			result = @data[name]
			puts "Result is #{result}"
			return result if result != nil
			return @data[:unknown]
		end

	end
end