module DoPracy

	class When_interpolating_two_track_points < Minitest::Test

		def setup
			p1 = TrackPoint.new 1, 2, 3, 4
			p2 = TrackPoint.new 7, 9, 9, 10
			interpolator = TrackPointInterpolator.new
			@result = interpolator.get p1, p2, 0.5
		end

		def test_should_get_type_from_earlier_point
			assert_equal 4, @result.type
		end

		def test_should_interpolate_lontitude_using_data_from_two_points
			assert_equal 5.5, @result.lon
		end

		def test_should_interpolate_latitude_using_data_from_two_points
			assert_equal 6, @result.lat
		end

		def test_should_interpolate_time_using_data_from_two_points
			assert_equal 4, @result.time
		end
	end
end