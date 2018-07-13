module DoPracy

	class QueueTests < MiniTest::Test

		def test_empty_queue_should_return_nil_for_each_index
			queue = PointsQueue.new (3)

			assert_nil queue[0]
			assert_nil queue[1]
			assert_nil queue[2]
		end

		def test_queue_should_return_last_pushed_element_for_first_index
			queue = PointsQueue.new (3)
			queue.push 'Franek'

			assert_equal 'Franek', queue[0]
			assert_nil queue[1]
			assert_nil queue[2]
		end

		def test_queue_should_return_one_befre_last_pushed_element_for_second_index
			queue = PointsQueue.new (3)
			queue.push 'Franek'
			queue.push 'Edek'

			assert_equal 'Edek', queue[0]
			assert_equal 'Franek', queue[1]
			assert_nil queue[2]
		end

		def test_pushing_new_element_to_a_full_queue_should_eliminate_the_oldest_value
			queue = PointsQueue.new (2)
			queue.push 'Franek'
			queue.push 'Edek'
			queue.push 'Czesiek'

			assert_equal 'Czesiek', queue[0]
			assert_equal 'Edek', queue[1]
		end

	end
end