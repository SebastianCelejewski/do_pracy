module DoPracy
	class Employee

		$queue_length = 160
		$number_of_dots = 20
		$queue_length_to_dots_count_ratio = $queue_length / $number_of_dots

		def initialize(window, name, transformer, track_data, show_tail, show_name)
			@window = window
			@name = name
			@transformer = transformer
			@track_data = track_data
			@show_tail = show_tail
			@show_name = show_name

			@dots = []
			(0...$number_of_dots).each do |i|
				ii = "%02d" % i
				@dots << Gosu::Image.new("./images/dot-#{ii}.png", false)
			end
			@points = PointsQueue.new $queue_length

			@font = Gosu::Font.new(window, "Times New Roman", 24)
		end

		def load_image (window, name)
			puts "Loading image #{name}"
			Gosu::Image.new("./images/icons/#{name}", false)		
		end

		def update(time)
			track_point = @track_data[time]
			if (track_point != nil)
				@lat = track_point.lat
				@lon = track_point.lon
				@type = track_point.type
				@points.push ({:lat => @lat, :lon => @lon})
				@visible = true
			else
				@visible = false
				@points.push ({:lat => nil, :lon => nil})
			end
		end

		def draw
			(0..$queue_length).each do |idx|
				next if @points[idx] == nil
				lon = @points[idx][:lon]
				lat = @points[idx][:lat]

				if (lon != nil && lat != nil && @show_tail)
					position = transform lon, lat
					x = position[:x]
					y = position[:y]
					@dots[idx/$queue_length_to_dots_count_ratio].draw_rot(x, y, 1, 0)
				end
			end

			if (@visible)
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

					if (@show_name)
						@font.draw(@name, x + 20, y, 2, 1, 1, 0xff_000000)
					end
				end

			end
		end

		def transform lon, lat
			return nil if lon == nil || lat == nil
			@transformer.get lat, lon
		end
	end
end