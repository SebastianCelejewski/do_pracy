require './SmartReader'

module DoPracy

	class Calculation

		def recalculate(times, values, start_time, end_time, delta_time)

			first_time = times.first
			last_time = times.last

			reader = SmartReader.new(times, values)

			result = Hash.new

			time = start_time

			while time <= end_time
				result[time] = reader.get(time)
				time = time + delta_time
			end
			return result
		end
	end

	times = [10, 11, 12, 13]
	values = [7, 9, 22, 5]
	start_time = 5
	end_time = 15
	delta_time = 0.5
	calculator = Calculation.new
	result = calculator.recalculate(times, values, start_time, end_time, delta_time)
	puts result.inspect
end
