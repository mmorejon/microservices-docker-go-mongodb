bundle: {
	apiVersion: "v1alpha1"
	name:       "cinema"
	instances: {
		website: {
			module: url:     "oci://ghcr.io/mmorejon/modules/website"
			module: version: "0.1.0"
			namespace: "default"
			values: args: [
				"-usersAPI",
				"http://users/api/users/",
				"-moviesAPI",
				"http://movies/api/movies/",
				"-showtimesAPI",
				"http://showtimes/api/showtimes/",
				"-bookingsAPI",
				"http://bookings/api/bookings/",
			]
		}
		users: {
			module: url:     "oci://ghcr.io/mmorejon/modules/users"
			module: version: "0.1.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
		}
		movies: {
			module: url:     "oci://ghcr.io/mmorejon/modules/movies"
			module: version: "0.1.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
		}
		showtimes: {
			module: url:     "oci://ghcr.io/mmorejon/modules/showtimes"
			module: version: "0.1.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
		}
		bookings: {
			module: url:     "oci://ghcr.io/mmorejon/modules/bookings"
			module: version: "0.1.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
		}
		mongodb: {
			module: url:     "oci://ghcr.io/mmorejon/modules/mongodb"
			module: version: "0.1.0"
			namespace: "default"
		}
	}
}
