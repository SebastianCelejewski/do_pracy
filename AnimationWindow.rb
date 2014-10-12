require 'gosu'

require './Employee'

module DoPracy

	class AnimationWindow < Gosu::Window
		def initialize width, height, background_image_file_path, length
			super width, height, false
			self.caption = "Gosu Tutorial Game"
			@background_image = Gosu::Image.new(self, background_image_file_path, true)
			@players = []
			@idx = 0
			@length = length
		end

		def add_player player
			@players << player
		end

		def update
			@players.each { |player| player.update(@idx)}
			@idx = @idx + 1
			@idx = 0 if @idx >= @length
		end

		def draw
			@background_image.draw(0, 0, 0)
			@players.each { |player| player.draw }
		end
	end
end