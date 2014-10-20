module DoPracy

	class Range

		attr_reader :min
		attr_reader :max

		def initialize(min = nil, max = nil)
			@min = min
			@max = max
		end

		def +(other)
			return Range.new(calculate_min(@min, other.min), calculate_max(@max, other.max))
		end

		def calculate_min (x, y)
			return x if y == nil
			return y if x == nil
			return [x, y].min
		end

		def calculate_max (x, y)
			return x if y == nil
			return y if x == nil
			return [x,y].max
		end

		def length
			@max - @min
		end

		def to_s
			return "#{min} - #{max}"
		end
	end
end
