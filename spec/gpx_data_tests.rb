require './spec/config.rb'

module DoPracy

	class GpxDataTests < MiniTest::Test

		def setup
			@gpxData = GpxData.new
			@gpxData.load_data("./spec/gpx_data_tests")

			@start_time = @gpxData.time_range.min
			@result = @gpxData.prepare 4

		end

		def test_when_time_is_before_employee_appeared_should_return_null
			time = Time.parse("2014-09-29T10:01:15Z")
			assert_equal nil, @result[1][time]
		end

		def test_when_type_is_not_provided_in_the_track_point_it_should_complement_it_from_previous_track_points
			refute_nil @result
			refute_nil @result[0]
			time = Time.parse("2014-09-29T10:00:00Z")
			refute_nil @result[0][time]
			assert_equal "bicycle", @result[0][time].type
		end	
	end
end