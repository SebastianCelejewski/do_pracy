module DoPracy

	class PointsQueue

		def initialize length
			@length = length
			@elements = []
		end

		def push new_element
			(1...@length).each do |idx|
				rev_idx = @length-idx
				@elements[rev_idx] = @elements[rev_idx-1]
			end
			@elements[0] = new_element
		end

		def [] idx
			@elements[idx]
		end

		def to_s
			@elements
		end
	end
end