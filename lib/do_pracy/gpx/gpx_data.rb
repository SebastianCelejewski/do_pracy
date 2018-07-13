module DoPracy

	class GpxData

		attr_reader :lat_range
		attr_reader :lon_range
		attr_reader :time_range
		attr_reader :length
		attr_reader :name

		def initialize
			@lat_range = Range.new
			@lon_range = Range.new
			@time_range = Range.new
			@length = 0
			@name = :unknown
			@track_point_interpolator = TrackPointInterpolator.new
		end

		def move_to_single_day(time) 
			hour = time.hour
			minute = time.min
			second = time.sec
			return Time.utc(2014,10,01,hour,minute,second)
		end

		def load_data(data_directory)
			puts "\nLoading track data from #{data_directory}"
			raw_track_data = Hash.new
			Dir["#{data_directory}/*.gpx"].each_with_index do |f, idx|
				xml = Nokogiri::XML(open(f))
				lats = xml.xpath("//gpx:trkpt/@lat","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| node.content.to_f}
				lons = xml.xpath("//gpx:trkpt/@lon","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| node.content.to_f}
				times = xml.xpath("//gpx:trkpt/gpx:time","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| Time.parse(node.content)}
				points = xml.xpath("//gpx:trkpt","gpx" => "http://www.topografix.com/GPX/1/1").map { |node| TrackPoint.from_node node }

				points.inject (:unknown) do |type, track_point|
					current_type = track_point.type
					track_point.type = type if track_point.type == :unknown
					track_point.type
				end

				lat_range = Range.new(lats.min, lats.max)
				lon_range = Range.new(lons.min, lons.max)
				time_range = Range.new(times.min, times.max)
				name = File.basename(f).split(/\./)[-2]

				puts "Track #{idx}, file: #{f}, name: #{name}, lon range: #{lon_range}, lat range: #{lat_range}, time_range: #{time_range}"

				@lat_range = @lat_range + lat_range
				@lon_range = @lon_range + lon_range
				@time_range = @time_range + time_range

				track_data = Hash.new
				track_data[:start_time] = @time_min
				track_data[:end_time] = @time_max
				track_data[:times] = times
				track_data[:points] = points
				track_data[:name] = name

				raw_track_data[idx] = track_data
				@length+=1
			end

			puts "Totals: tracks: #{raw_track_data.length}, lon range: #{@lon_range}, lat range: #{@lat_range}, time_range: #{@time_range}"
			puts "Track loading complete."
			return raw_track_data
		end

		def prepare(raw_track_data, number_of_steps)
			puts "\nPreparing data to animate #{number_of_steps} frames."
			start_time = @time_range.min
			end_time = @time_range.max
			delta_time = (@time_range.max - @time_range.min ) / number_of_steps

			puts "Start time: #{start_time}, end time: #{end_time}, delta time: #{delta_time}"
			point_calculation = Calculation.new @track_point_interpolator

			result = []

			(0...raw_track_data.length).each do |idx|
				track_data = raw_track_data[idx]
				puts "Calculating track #{idx}"
				recalculated_points = point_calculation.recalculate track_data[:times], track_data[:points], start_time, end_time, delta_time
				result << recalculated_points
			end

			puts "Data preparation complete"
			return result
		end
	end
end