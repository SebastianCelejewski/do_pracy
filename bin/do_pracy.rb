require './lib/do_pracy'

module DoPracy

	puts "Do pracy, rodacy!\n"

	$data_dir = './data'
	$images_dir = "./images"

	if !Dir.exist?($data_dir)
		puts "Create ./data directory and put gpx tracks there."
		exit
	end

	puts "Initialization started"

	zoom = 11
	number_of_steps = 5000

  puts "Loading GPS data"
	gpx_data = GpxData.new
	gpx_data.load_data($data_dir)
	track_data = gpx_data.prepare number_of_steps

	#map_provider = ServerMapProvider.new zoom, gpx_data.lon_range, gpx_data.lat_range
	map_provider = FileMapProvider.new "h48_TR200.json"
	transformer = map_provider.get_transformer

	puts "Creating base map"
	map_image = map_provider.get_map_image
	map_width = map_provider.get_width
	map_height = map_provider.get_height

	puts "\nCreating animation window"
	start_time = gpx_data.time_range.min
	end_time = gpx_data.time_range.max
	time_step = (gpx_data.time_range.max - gpx_data.time_range.min) / number_of_steps
	window = AnimationWindow.new(map_width, map_height, map_image, start_time, end_time, time_step)

	puts "Creating animation objects"
	(0...gpx_data.length).each do |employee|
		puts "Creating object #{employee}"
		name = employee.to_s
		window.add_player Employee.new(window, name, transformer, track_data[employee])
	end

  puts "Creating clock"
	clock = Clock.new window
	window.add_clock clock

	puts "Initialization complete"
	puts ""

	puts "Starting animation"
	window.show

end
