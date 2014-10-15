module DoPracy

	class GpxData

		attr_reader :lat_range
		attr_reader :lon_range
		attr_reader :time_range
		attr_reader :length

		def initialize
			@lat_range = Range.new
			@lon_range = Range.new
			@time_range = Range.new
			@length = 0
			@track_point_interpolator = TrackPointInterpolator.new
			@float_interpolator = FloatInterpolator.new
		end

		def move_to_single_day(time) 
			hour = time.hour
			minute = time.min
			second = time.sec
			return Time.utc(2014,10,01,hour,minute,second)
		end

		def get_type file_name

			return :unknown if file_name == nil

			if /-([^_]*)\./.match(file_name)
				return /-([^_]*)\./.match(file_name)[1]
			else
				return :unknown
			end
		end

		def load_data(data_directory)
			puts "\nLoading track data from #{data_directory}"
			@data = Hash.new
			Dir["#{data_directory}/*.gpx"].each_with_index do |f, idx|
				xml = Nokogiri::XML(open(f))
				lats = xml.xpath("//gpx:trkpt/@lat","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| node.content.to_f}
				lons = xml.xpath("//gpx:trkpt/@lon","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| node.content.to_f}
				times = xml.xpath("//gpx:trkpt/gpx:time","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| move_to_single_day(Time.parse(node.content))}
				points = xml.xpath("//gpx:trkpt","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| TrackPoint.from_node node }

				points.inject (:unknown) do |type, track_point|
					current_type = track_point.type
					track_point.type = type if track_point.type == :unknown
					track_point.type
				end

				lat_range = Range.new(lats.min, lats.max)
				lon_range = Range.new(lons.min, lons.max)
				time_range = Range.new(times.min, times.max)
				type = get_type f

				puts "Track #{idx}, file: #{f}, lon range: #{lon_range}, lat range: #{lat_range}, time_range: #{time_range}, type: #{type}"

				@lat_range = @lat_range + lat_range
				@lon_range = @lon_range + lon_range
				@time_range = @time_range + time_range

				track_data = Hash.new
				track_data[:start_time] = @time_min
				track_data[:end_time] = @time_max
				track_data[:times] = times
				track_data[:lats] = lats
				track_data[:lons] = lons
				track_data[:type] = type
				track_data[:points] = points

				@data[idx] = track_data
				@length+=1
			end

			puts "Totals: tracks: #{@data.length}, lon range: #{@lon_range}, lat range: #{@lat_range}, time_range: #{@time_range}"
			puts "Track loading complete."
		end

		def prepare(number_of_steps)
			puts "\nPreparing data to animate #{number_of_steps} frames."
			start_time = @time_range.min
			end_time = @time_range.max
			delta_time = (@time_range.max - @time_range.min ) / number_of_steps

			puts "Start time: #{start_time}, end time: #{end_time}, delta time: #{delta_time}"
			float_calculation = Calculation.new @float_interpolator
			point_calculation = Calculation.new @track_point_interpolator

			result = []

			(0...@data.length).each do |idx|
				track_data = @data[idx]

				puts "Calculating track #{idx}"

				lat_data = float_calculation.recalculate track_data[:times], track_data[:lats], start_time, end_time, delta_time
				lon_data = float_calculation.recalculate track_data[:times], track_data[:lons], start_time, end_time, delta_time
				recalculated_points = point_calculation.recalculate track_data[:times], track_data[:points], start_time, end_time, delta_time

				@data[idx][:lat_points] = lat_data
				@data[idx][:lon_points] = lon_data
				@data[idx][:type] = track_data[:type]
				@data[idx][:points] = recalculated_points
				result << recalculated_points
			end

			puts "Data preparation complete"
			return result
		end

		def get(employee_idx, time_step)
			track_data = @data[employee_idx]

			lat = track_data[:lat_points][time_step]
			lon = track_data[:lon_points][time_step]
			type = track_data[:type]

			return {:lat => lat, :lon => lon, :type => type }
		end
	end
end