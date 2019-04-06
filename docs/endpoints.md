# Cinema - Endpoints

## User Service

This service returns information about the users of Cinema.

**_Routes:_**

* GET - http://users.local/users : Get all users
* POST - http://users.local/users : Create user
* DELETE - http://users.local/users/{id} : Remove user by id

## Movie Service

This service is used to get information about a movie. It provides the movie title, rating on a 1-10 scale, director and other information.

**_Routes:_**

* GET - http://movies.local/movies : Get all movies
* POST - http://movies.local/movies : Create movie
* GET - http://movies.local/movies/{id} : Get movie by id
* DELETE - http://movies.local/movies/{id} : Remove movie by id

## Showtimes Service

This service is used get a list of movies playing on a certain date.

**_Routes:_**

* GET - http://showtimes.local/showtimes : Get all showtimes
* POST - http://showtimes.local/showtimes : Create showtime
* GET - http://showtimes.local/showtimes/{id} : Get showtime by id
* DELETE - http://showtimes.local/showtimes/{id} : Remove showtime by id

## Booking Service

Used to lookup booking information for users.

**_Routes:_**

* GET - http://bookings.local/bookings : Get all bookings
* POST - http://bookings.local/bookings : Create booking