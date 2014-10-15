module DoPracy

	class TrackPointInterpolator

		def get(track_point_1, track_point_2, delta)
			time1 = track_point_1.time
			time2 = track_point_2.time

			lon1 = track_point_1.lon
			lon2 = track_point_2.lon

			lat1 = track_point_1.lat
			lat2 = track_point_2.lat

			type = track_point_1.type

			time = time1 + delta * (time2 - time1)
			lat = lat1 + delta * (lat2 - lat1)
			lon = lon1 + delta * (lon2 - lon1)

			result = TrackPoint.new time, lon, lat, type
		end
	end
end