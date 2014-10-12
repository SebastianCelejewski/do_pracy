require './PointsQueue'
require './transformer'

module DoPracy
	class Employee

		$queue_length = 40
		$number_of_dots = 20

		def initialize(window, data, transformer)
			@image = Gosu::Image.new(window, "./images/bicycle.png", false)
			@dots = []
			(0...$number_of_dots).each do |i|
				ii = "%02d" % i
				@dots << Gosu::Image.new(window, "./images/dot-#{ii}.png", false)
			end
			@data = data
			@window = window
			@points = PointsQueue.new $queue_length
			@transformer = transformer
		end

		def update(idx)
			@lat = @data[idx][:lat]
			@lon = @data[idx][:lon]
			@points.push ({:lat => @lat, :lon => @lon}) #if idx % 2 == 0
		end

		def draw
			(0..$queue_length).each do |idx|
				next if @points[idx] == nil
				lon = @points[idx][:lon]
				lat = @points[idx][:lat]

				if (lon != nil && lat != nil)
					position = transform lon, lat
					x = position[:x]
					y = position[:y]
					@dots[idx/2].draw_rot(x, y, 1, 0)
				end
			end

			position = transform @lon, @lat
			if position != nil
				x = position[:x]
				y = position[:y]
				@image.draw_rot(position[:x], position[:y], 2, 0) if position != nil
			end
		end

		def transform lon, lat
			return nil if lon == nil || lat == nil
			@transformer.get lat, lon
		end
	end
end