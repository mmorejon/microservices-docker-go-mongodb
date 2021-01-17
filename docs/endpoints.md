# Cinema - Endpoints

## User Service

This service returns information about the users of Cinema.

| Service | Method | Endpoint       |
|---------|--------|----------------|
| List users | `GET` | `/api/users/` |
| Get user by Id | `GET` | `/api/users/{id}` |
| Insert user | `POST` | `/api/users/` |
| Delete user | `DELETE` | `/api/users/{id}` |

## Movie Service

This service is used to get information about a movie. It provides the movie title, rating on a 1-5 scale, director and other information.

| Service | Method | Endpoint       |
|---------|--------|----------------|
| List movies | `GET` | `/api/movies/` |
| Get movie by Id | `GET` | `/api/movies/{id}` |
| Insert movie | `POST` | `/api/movies/` |
| Delete movie | `DELETE` | `/api/movies/{id}` |

## Showtimes Service

This service is used get a information about showtimes playing on a certain date.

| Service | Method | Endpoint       |
|---------|--------|----------------|
| List showtimes | `GET` | `/api/showtimes/` |
| Get showtime by Id | `GET` | `/api/showtimes/{id}` |
| Get showtime by date | `GET` | `/api/showtimes/filter/date/{date}` |
| Insert showtime | `POST` | `/api/showtimes/` |
| Delete showtime | `DELETE` | `/api/showtimes/{id}` |

## Booking Service

Used to lookup booking information for users.

| Service | Method | Endpoint       |
|---------|--------|----------------|
| List bookings | `GET` | `/api/bookings/` |
| Get booking by Id | `GET` | `/api/bookings/{id}` |
| Insert booking | `POST` | `/api/bookings/` |
| Delete booking | `DELETE` | `/api/bookings/{id}` |