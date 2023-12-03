bundle: {
	apiVersion: "v1alpha1"
	name:       "cinema"
	instances: {
		website: {
			module: url:     "oci://ghcr.io/mmorejon/modules/website"
			module: version: "0.2.0"
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
		bookings: {
			module: url:     "oci://ghcr.io/mmorejon/modules/api"
			module: version: "0.2.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
			values: image: {
				repository: "ghcr.io/mmorejon/cinema-bookings"
				digest:     "sha256:9b51714509861b1dad066f56f1c1e5387f20828b113c6d557761fa5b11eef858"
				tag:        "v2.2.2"
			}
		}
		movies: {
			module: url:     "oci://ghcr.io/mmorejon/modules/api"
			module: version: "0.2.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
			values: image: {
				repository: "ghcr.io/mmorejon/cinema-movies"
				digest:     "sha256:6f15801d3fa8fbfa58b6718851c28841e010935c205b5770c7deb949fc2e2e25"
				tag:        "v2.2.2"
			}
		}
		showtimes: {
			module: url:     "oci://ghcr.io/mmorejon/modules/api"
			module: version: "0.2.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
			values: image: {
				repository: "ghcr.io/mmorejon/cinema-showtimes"
				digest:     "sha256:70d087aaf0e888310cfb585eb81e308721e38bb96819e2908358131be1fc2dc8"
				tag:        "v2.2.2"
			}
		}
		users: {
			module: url:     "oci://ghcr.io/mmorejon/modules/api"
			module: version: "0.2.0"
			namespace: "default"
			values: args: [
				"-mongoURI",
				"mongodb://mongodb:27017/",
			]
			values: image: {
				repository: "ghcr.io/mmorejon/cinema-users"
				digest:     "sha256:3a1e8fd1f3cb832981bcadb3fff056eb0a2300cf7cb6bf94460c6bccdd6743ed"
				tag:        "v2.2.2"
			}
		}
		mongodb: {
			module: url:     "oci://ghcr.io/mmorejon/modules/mongodb"
			module: version: "0.2.0"
			namespace: "default"
		}
	}
}
