require 'nokogiri'
require 'net/http'
require './TileDownloader'
require './GpxData'
require './AnimationWindow'
require './Transformer'
require './Images'

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

	Dir.mkdir($temp_dir) if !Dir.exist?($temp_dir)
	Dir.mkdir($tiles_dir) if !Dir.exist?($tiles_dir)

	puts "Initialization started"

	zoom = 10
	downloader = TileDownloader.new
	gpxData = GpxData.new

	gpxData.load_data($data_dir)

	number_of_steps = 1000

	gpxData.prepare number_of_steps

	transformer = Transformer.new(gpxData.lat_range, gpxData.lon_range, zoom)

	start_time = gpxData.time_range.min
	end_time = gpxData.time_range.max
	time_step = (gpxData.time_range.max - gpxData.time_range.min) / number_of_steps

	puts "Creating base map"
	tile_range = transformer.tile_range
	base_map = downloader.create_base_map(zoom, tile_range)

	width = (tile_range[:x_range] + 1) * 256
	height = (tile_range[:y_range] + 1) * 256

	puts "Creating animation window"
	window = AnimationWindow.new(width, height, base_map,  number_of_steps)

	images = Images.new window

	puts "Creating employees"
	(0...gpxData.length).each do |employee|
		puts "Creating object #{employee}"
		time = start_time
		points = []
		while (time < end_time)
			points << gpxData.get(employee, time)
			time += time_step
		end
		window.add_player Employee.new(window, points, transformer, images)
	end

	puts "Initialization complete"
	puts ""

	puts "Starting animation"
	window.show

end