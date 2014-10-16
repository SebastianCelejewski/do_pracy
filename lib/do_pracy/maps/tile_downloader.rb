require 'uri'
require 'net/http'

module DoPracy

	class TileDownloader

		def create_base_map (zoom, tile_range)
			x1 = tile_range[:x_min]
			x2 = tile_range[:x_max]
			y1 = tile_range[:y_max]
			y2 = tile_range[:y_min]

			puts "Creating base map for range (#{x1},#{y1}) (#{x2},#{y2})"

			row_idx = 0
			merged_file_name = "#{$temp_dir}/merged.png"
			vertical_merge_command = "convert "
			for j in y1..y2
				horizontal_merge_command = "convert "
				for i in x1..x2
					tile = get_tile(zoom, i, j)
					horizontal_merge_command += "#{tile} "
				end
				row_file = "#{$temp_dir}/row-#{row_idx}.png"
				horizontal_merge_command += " +append #{row_file}"
				`#{horizontal_merge_command}`
				vertical_merge_command += "#{row_file} "
				row_idx = row_idx + 1
			end
			vertical_merge_command += " -append #{merged_file_name}"
			`#{vertical_merge_command}`
			return merged_file_name
		end

		def get_tile(zoom, x, y)
			puts "Getting tile #{zoom}, #{x}, #{y}"
			file_name = $file_name_pattern % [zoom, x, y]
			file_path = "#{$tiles_dir}/#{file_name}"
			if !File.exist?(file_path)
				url = $url_pattern % [zoom, x, y]
				image = download_tile(url)
				File.open(file_path, 'wb') { |f| f.write(image) }
			end

			return file_path				
		end

		def download_tile (url)
			puts "Downloading tile #{url}"
			uri = URI(url)
			Net::HTTP.start(uri.host) do |http|
				resp = http.get(uri.path)
				return resp.body
			end
		end
	end
end