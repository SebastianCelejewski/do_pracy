module DoPracy

	class SmartReaderTests < MiniTest::Unit::TestCase

		def set_up
			@times = [10, 11, 12, 13]
			@values = [7, 9, 22, 5]
			@cut = SmartReader.new(@times, @values)
		end

		def test_should_return_null_when_time_is_earlier_than_the_first_point
			set_up
			assert_equal nil, @cut.get(8)
		end

		def test_should_return_value_of_the_first_point_when_time_points_to_the_first_point
			set_up
			assert_equal 7, @cut.get(10)
		end

		def test_should_return_value_of_the_second_point_when_time_points_to_the_second_point
			set_up
			assert_equal 9, @cut.get(11)
		end

		def test_should_return_value_of_the_last_point_when_time_points_to_the_last_point
			set_up
			assert_equal 5, @cut.get(13)
		end

		def test_should_return_the_average_value_of_the_first_and_second_point_when_time_is_between_the_first_and_the_second_point
			set_up
			assert_equal 8, @cut.get(10.5)
		end
	end
end