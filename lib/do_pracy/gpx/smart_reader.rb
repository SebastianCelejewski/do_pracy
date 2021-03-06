module DoPracy

	class SmartReader

		def initialize(times, values, interpolator)
			@times = times
			@values = values
			@interpolator = interpolator
			@ptr = 0
			select_section(@ptr)
		end

		def select_section(ptr)
			@ptr = ptr
			@section_start_time = @times[@ptr]
			@section_end_time = @times[@ptr + 1]
			@section_start_value = @values[@ptr]
			@section_end_value = @values[@ptr + 1]
			@section_time_span = @section_end_time - @section_start_time
		end

		def get(time)
			return @section_start_value if time == @section_start_time
			return @section_end_value if time == @section_end_time

			return nil if time < @times.first
			return nil if time > @times.last

			while time > @section_end_time
				select_section(@ptr + 1)
			end

			while time < @section_start_time
				select_section(@ptr - 1)
			end

			delta_time = time - @section_start_time
			return @interpolator.get(@section_start_value, @section_end_value, (delta_time / @section_time_span))
		end
	end
end