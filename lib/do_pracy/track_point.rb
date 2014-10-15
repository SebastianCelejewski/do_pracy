require 'tzinfo'

module DoPracy

	class TrackPoint

		attr_reader :time
		attr_reader	:lon
		attr_reader	:lat
		attr_reader	:type

		def initialize (time, lon, lat, type)
			@time = time
			@lon = lon
			@lat = lat
			@type = type
		end

		def self.from_node node
			lat = node.attribute("lat").content.to_f
			lon = node.attribute("lon").content.to_f
			time_str = node.xpath("gpx:time","gpx" => "http://www.topografix.com/GPX/1/1").first
			type_str = node.xpath("gpx:type","gpx" => "http://www.topografix.com/GPX/1/1").first
			time = Time.parse(time_str.content)
			type = :unknown
			type = type_str.content if type_str != nil

			return TrackPoint.new time, lon, lat, type
		end
	end
end