require 'minitest/autorun'
require 'nokogiri'

module DoPracy

	class When_creating_TrackPoint_from_xml_node < MiniTest::Test

		def setup
			doc_with_type = Nokogiri::XML(open('./spec/track_point_tests-with_type.xml'))
			doc_without_type = Nokogiri::XML(open('./spec/track_point_tests-without_type.xml'))

			node_with_type = doc_with_type.xpath("//gpx:trkpt", "gpx" => "http://www.topografix.com/GPX/1/1")
			node_without_type = doc_without_type.xpath("//gpx:trkpt", "gpx" => "http://www.topografix.com/GPX/1/1")

			@track_point_with_type = TrackPoint.from_node node_with_type
			@track_point_without_type = TrackPoint.from_node node_without_type
		end

		def test_should_get_time_from_time_node
			assert_equal Time.parse('2014-09-29T05:02:38Z'), @track_point_with_type.time
		end

		def test_should_get_lontitude_from_lon_attribute
			assert_equal 18.448622, @track_point_with_type.lon
		end

		def test_should_get_latitude_from_lat_attribute
			assert_equal 54.500128, @track_point_with_type.lat
		end

		def test_should_get_type_from_type_node
			assert_equal "bicycle", @track_point_with_type.type
		end

		def test_should_return_unknown_type_when_type_is_not_provided
			assert_equal :unknown, @track_point_without_type.type
		end
	end
end