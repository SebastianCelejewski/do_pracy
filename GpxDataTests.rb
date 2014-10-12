require 'minitest/autorun'

require './GpxData'

module DoPracy

	class GpxDataTests < MiniTest::Unit::TestCase

		def set_up
			@gpxData = GpxData.new
			@gpxData.load_data("./data")

			@start_time = @gpxData.time_range.min
			@gpxData.prepare 100

		end

		def test_when_time_is_before_employee_appeared_should_return_null_lon
			set_up
			time = Time.parse("2014-10-01T06:26:35Z")
			data = @gpxData.get(0, time)
			assert_equal nil, data[:lon]
		end

		def test_when_time_is_before_employee_appeared_should_return_null_lat
			set_up
			time = Time.parse("2014-10-01T06:26:35Z")
			data = @gpxData.get(0, time)
			assert_equal nil, data[:lat]
		end

		def test_when_time_is_when_employee_appeared_should_return_initial_lon
			set_up
			time = Time.parse("2014-10-01T05:31:26Z")
			data = @gpxData.get(0, time)
			assert_equal 18.533328, data[:lon]
		end

		def test_when_time_is_when_employee_appeared_should_return_initial_lat
			set_up
			time = Time.parse("2014-10-01T05:30:23Z")
			data = @gpxData.get(0, time)
			assert_equal 54.350018, data[:lat]
		end
	end
end