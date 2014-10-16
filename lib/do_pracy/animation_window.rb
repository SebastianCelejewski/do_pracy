module DoPracy
	class AnimationWindow < Gosu::Window
		def initialize width, height, background_image_file_path, length, start_time, end_time, time_step
			super width, height, false
			self.caption = "Gosu Tutorial Game"
			@background_image = Gosu::Image.new(self, background_image_file_path, true)
			@players = []
			@idx = 0
			@length = length
			@start_time = start_time
			@end_time = end_time
			@time_step = time_step

			@time = @start_time
		end

		def add_player player
			@players << player
		end

		def add_clock clock
			@clock = clock
		end

		def update
			@players.each { |player| player.update(@idx)}
			@clock.update @idx
			@idx = @idx + 1
			@idx = 0 if @idx >= @length
			@time = @time + @time_step
			@time = @start_time if @time >= @end_time
		end

		def draw
			@background_image.draw(0, 0, 0)
			@players.each { |player| player.draw }
			@clock.draw
		end
	end
end