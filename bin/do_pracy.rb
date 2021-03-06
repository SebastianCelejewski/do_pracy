require './lib/do_pracy'

module DoPracy

	puts "Do pracy, rodacy!\n"

	$file_name_pattern = "tile-%s-%s-%s.png"
	$url_pattern = "http://tile.openstreetmap.org/%s/%s/%s.png"
	$data_dir = './data'
	$tiles_dir = './tiles'
	$temp_dir = "./temp"
	$images_dir = "./images"

	if !Dir.exist?($data_dir)
		puts "Create ./data directory and put gpx tracks there."
		exit
	end

	command_line_parser = CommandLineParser.new
	options = command_line_parser.parse

	Dir.mkdir($temp_dir) if !Dir.exist?($temp_dir)
	Dir.mkdir($tiles_dir) if !Dir.exist?($tiles_dir)

	zoom = options[:zoom]
	number_of_steps = options[:steps]

	downloader = TileDownloader.new
	gpxData = GpxData.new

	raw_track_data = gpxData.load_data($data_dir)
	track_data = gpxData.prepare raw_track_data, number_of_steps

	transformer = Transformer.new(gpxData.lat_range, gpxData.lon_range, zoom)

	start_time = gpxData.time_range.min
	end_time = gpxData.time_range.max
	time_step = (gpxData.time_range.max - gpxData.time_range.min) / number_of_steps

	tile_range = transformer.tile_range
	base_map = downloader.create_base_map(zoom, tile_range)

	width = (tile_range[:x_range] + 1) * 256
	height = (tile_range[:y_range] + 1) * 256

	puts "\nCreating animation window"
	window = AnimationWindow.new(width, height, base_map, start_time, end_time, time_step)

	print "Creating animation objects: "
	(0...gpxData.length).each do |idx|
		print "."
		name = raw_track_data[idx][:name]
		window.add_player Employee.new(window, name, transformer, track_data[idx], options[:show_tails], options[:show_names])
	end
	puts ""

	clock = Clock.new window

	window.add_clock clock

	puts "Initialization complete"
	puts ""

	puts "Starting animation"
	window.show

end