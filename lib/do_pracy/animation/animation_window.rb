module DoPracy
	class AnimationWindow < Gosu::Window
		def initialize width, height, background_image_file_path, start_time, end_time, time_step
			super width, height, false
			@width = width
			@height = height
			self.caption = "Do pracy (gpx data visualization)"
			@background_image = Gosu::Image.new(self, background_image_file_path, true)
			@players = []
			@start_time = start_time
			@end_time = end_time
			@time_step = time_step

			@time = @start_time
			@delay_length = 300
			@startup_delay = 0
			@shutdown_delay = 0
		end

		def add_player player
			@players << player
		end

		def add_clock clock
			@clock = clock
		end

		def update
			@clock.update @time

			if @startup_delay < @delay_length
				@startup_delay += 1
				return
			end

			@players.each { |player| player.update(@time)}

			@time = @time + @time_step

			if @time >= @end_time
				@shutdown_delay += 1
				if @shutdown_delay >= @delay_length
					@time = @start_time 
					@shutdown_delay = 0
					@startup_delay = 0
				end
			end
		end

		def draw
			@background_image.draw(0, 0, 0)
			@players.each { |player| player.draw }
			@clock.draw
		end
	end
end