module DoPracy

	class Clock

		def initialize window
			@window = window
			@hour_hand = Gosu::Image.new("./images/icons/hour_hand.png", false)
			@minute_hand = Gosu::Image.new("./images/icons/minute_hand.png", false)
			puts "Loading font..."
			@font = Gosu::Font.new(window, "Times New Roman", 24)
			puts "Font loaded."
		end

		def update(time)
			@hour = time.hour + 2
			@minute = time.min

			@hour_angle = 360*(@hour.to_f + @minute.to_f/60)/12
			@minute_angle = 360*@minute.to_f/60
		end

		def draw
#			@hour_hand.draw_rot(100, 100, 2, @hour_angle)
#			@minute_hand.draw_rot(100, 100, 2, @minute_angle)
			@font.draw("#{@hour}:%02d" % @minute, 10, 10, 2, 1, 1, 0xff000000)
		end
	end
end