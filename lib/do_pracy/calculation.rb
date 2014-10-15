module DoPracy

	class Calculation

		def initialize interpolator
			@interpolator = interpolator
		end

		def recalculate(times, values, start_time, end_time, delta_time)

			first_time = times.first
			last_time = times.last

			reader = SmartReader.new(times, values, @interpolator)

			result = Hash.new

			time = start_time

			while time <= end_time
				result[time] = reader.get(time)
				time = time + delta_time
			end
			return result
		end
	end
end