module DoPracy

	class Clock

		def initialize window
			@window = window
			@hour_hand = Gosu::Image.new(window, "./images/icons/hour_hand.png", false)
			@minute_hand = Gosu::Image.new(window, "./images/icons/minute_hand.png", false)
		end

		def update(time)
			@hour = time.hour + 2
			@minute = time.min

			@hour_angle = 360*(@hour.to_f + @minute.to_f/60)/12
			@minute_angle = 360*@minute.to_f/60
		end

		def draw
			@hour_hand.draw_rot(100, 100, 2, @hour_angle)
			@minute_hand.draw_rot(100, 100, 2, @minute_angle)
		end
	end
end