module DoPracy

	class FloatInterpolator

		def get x, y, delta
			return x + delta * (y - x)
		end
	end
end