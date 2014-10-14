class DoPracy::Transformer

	attr_reader :tile_range

	def initialize lat_range, lon_range, zoom

		@lat_max = lat_range.max
		@lat_min = lat_range.min
		@lon_min = lon_range.min
		@lon_max = lon_range.max
		@zoom = zoom

		@reference = get_tile_number(@lat_max, @lon_min)
		calculate_tile_range lat_range, lon_range
	end

	def get lat, lon
		tile = get_tile_number lat, lon
		result_x = tile[:x] - @reference[:x].to_i
		result_y = tile[:y] - @reference[:y].to_i
#			puts "(#{lon},#{lat}) => (#{tile[:x]},#{tile[:y]}) - (#{@reference[:x]},#{@reference[:y]}) = (#{result_x},#{result_y})"
		{:x => result_x*256, :y => result_y*256}
	end

	def calculate_tile_range (lat_range, lon_range)
		puts "\nCalculating tile range for latitudes #{lat_range} and lontitudes #{lon_range}"
		tile_min = get_tile_number lat_range.min, lon_range.min
		tile_max = get_tile_number lat_range.max, lon_range.max

		@tile_range = {
				:x_min => tile_min[:x].to_i,
				:x_max => tile_max[:x].to_i,
				:y_min => tile_min[:y].to_i,
				:y_max => tile_max[:y].to_i,
				:x_range => tile_max[:x].to_i - tile_min[:x].to_i,
				:y_range => tile_min[:y].to_i - tile_max[:y].to_i
			}

		puts "Calculated tiles range: #{@tile_range}"
	end

	def get_tile_number lat, lon
		lat_rad = lat * Math::PI / 180
		n = 2.0 ** @zoom
		x = (lon + 180.0) / 360.0 * n
		y = (1.0 - Math::log(Math::tan(lat_rad) + (1 / Math::cos(lat_rad))) / Math::PI) / 2.0 * n
		{:x => x, :y =>y}
	end
end