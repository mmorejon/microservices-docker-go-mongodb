#! /bin/bash
mongorestore -d users -c users /backup/users/users/users.bson
mongorestore -d movies -c movies /backup/movies/movies/movies.bson
mongorestore -d showtimes -c showtimes /backup/showtimes/showtimes/showtimes.bson
mongorestore -d bookings -c bookings /backup/bookings/bookings/bookings.bson