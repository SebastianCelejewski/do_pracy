module DoPracy

	class GpxDataTests < MiniTest::Unit::TestCase

		def setup
			@gpxData = GpxData.new
			@gpxData.load_data("./data")

			@start_time = @gpxData.time_range.min
			@gpxData.prepare 100

		end

		def test_when_time_is_before_employee_appeared_should_return_null_lon
			time = Time.parse("2014-10-01T06:26:35Z")
			data = @gpxData.get(0, time)
			assert_equal nil, data[:lon]
		end

		def test_when_time_is_before_employee_appeared_should_return_null_lat
			time = Time.parse("2014-10-01T06:26:35Z")
			data = @gpxData.get(0, time)
			assert_equal nil, data[:lat]
		end
	end
end