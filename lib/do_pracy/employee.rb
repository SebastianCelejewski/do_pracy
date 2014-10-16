module DoPracy
	class Employee

		$queue_length = 40
		$number_of_dots = 20

		def initialize(window, data, transformer, track_data)
			@dots = []
			(0...$number_of_dots).each do |i|
				ii = "%02d" % i
				@dots << Gosu::Image.new(window, "./images/dot-#{ii}.png", false)
			end
			@data = data
			@window = window
			@points = PointsQueue.new $queue_length
			@transformer = transformer
			@track_data = track_data
		end

		def load_image (window, name)
			puts "Loading image #{name}"
			Gosu::Image.new(window, "./images/icons/#{name}", false)		
		end

		def update(idx)
			@lat = @data[idx][:lat]
			@lon = @data[idx][:lon]
			@points.push ({:lat => @lat, :lon => @lon}) #if idx % 2 == 0
			@type = @data[idx][:type]
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

				image_name = "#{@type}.png"
				if image_name == @last_image_name
					@last_image.draw_rot(position[:x], position[:y], 2, 0) if position != nil
				else
					@last_image_name = image_name
					@last_image=load_image @window, "#{@type}.png"
					@last_image.draw_rot(position[:x], position[:y], 2, 0) if position != nil
				end
				#@image.draw_rot(position[:x], position[:y], 2, 0) if position != nil
			end
		end

		def transform lon, lat
			return nil if lon == nil || lat == nil
			@transformer.get lat, lon
		end
	end
end