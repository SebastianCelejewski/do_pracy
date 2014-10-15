require './spec/config.rb'

module DoPracy

	class CalculationTests < MiniTest::Test

		def set_up
			@times = [10, 11, 12, 13]
			@values = [7, 9, 22, 5]
			@start_time = 5
			@end_time = 15
			@delta_time = 0.5
			@calculator = Calculation.new FloatInterpolator.new
			@result = @calculator.recalculate(@times, @values, @start_time, @end_time, @delta_time)
		end

		def test_should_return_null_when_time_is_earlier_than_the_first_point
			set_up
			assert_equal nil, @result[5.0]
		end

		def test_should_return_value_of_the_first_point_when_time_points_to_the_first_point
			set_up
			assert_equal 7, @result[10.0]
		end

		def test_should_return_value_of_the_second_point_when_time_points_to_the_second_point
			set_up
			assert_equal 9, @result[11.0]
		end

		def test_should_return_the_average_value_of_the_first_and_second_point_when_time_points_between_first_and_second_point
			set_up
			assert_equal 8, @result[10.5]
		end
	end
end