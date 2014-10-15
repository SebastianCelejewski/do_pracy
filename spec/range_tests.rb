module DoPracy

	class RangeTests < MiniTest::Unit::TestCase

		def test_non_empty_range_should_have_min_value
			range = Range.new 1, 2
			assert_equal 1, range.min
		end

		def test_non_empty_range_should_have_max_value
			range = Range.new 1, 2
			assert_equal 2, range.max
		end

		def test_empty_range_should_not_have_min_value
			range = Range.new
			assert_equal nil, range.min
		end

		def test_empty_range_should_have_max_value
			range = Range.new
			assert_equal nil, range.max
		end

		def test_sum_of_two_empty_ranges_is_empty
			r1 = Range.new
			r2 = Range.new
			assert_equal nil, (r1+r2).min
			assert_equal nil, (r1+r2).max
		end

		def test_min_of_sum_of_two_non_empty_ranges_is_min_of_their_mins
			r1 = Range.new 1, 5
			r2 = Range.new 2, 9
			assert_equal 1, (r1 + r2).min
		end

		def test_max_of_sum_of_two_non_empty_ranges_is_max_of_their_max
			r1 = Range.new 1, 5
			r2 = Range.new 2, 9
			assert_equal 9, (r1 + r2).max
		end

		def test_min_of_sum_of_empty_and_non_empty_range_is_min_of_non_empty_range
			r1 = Range.new 
			r2 = Range.new 2, 9
			assert_equal 2, (r1 + r2).min
		end

		def test_max_of_sum_of_empty_and_non_empty_range_is_max_of_non_empty_range
			r1 = Range.new 
			r2 = Range.new 2, 9
			assert_equal 9, (r1 + r2).max
		end
	end
end