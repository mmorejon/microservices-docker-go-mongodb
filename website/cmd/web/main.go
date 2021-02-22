package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

type apis struct {
	users string
	movies string
	showtimes string
	bookings string
}

type application struct {
	errorLog *log.Logger
	infoLog  *log.Logger
	apis apis
}

func main() {

	// Define command-line flags
	serverAddr := flag.String("serverAddr", "", "HTTP server network address")
	serverPort := flag.Int("serverPort", 8000, "HTTP server network port")
	usersAPI := flag.String("usersAPI", "http://localhost:4000/api/users/", "Users API")
	moviesAPI := flag.String("moviesAPI", "http://localhost:4000/api/movies/", "Movies API")
	showtimesAPI := flag.String("showtimesAPI", "http://localhost:4000/api/showtimes/", "Showtimes API")
	bookingsAPI := flag.String("bookingsAPI", "http://localhost:4000/api/bookings/", "Bookings API")
	flag.Parse()

	// Create logger for writing information and error messages.
	infoLog := log.New(os.Stdout, "INFO\t", log.Ldate|log.Ltime)
	errLog := log.New(os.Stderr, "ERROR\t", log.Ldate|log.Ltime|log.Lshortfile)

	// Initialize a new instance of application containing the dependencies.
	app := &application{
		infoLog:  infoLog,
		errorLog: errLog,
		apis: apis{
			users: *usersAPI,
			movies: *moviesAPI,
			showtimes: *showtimesAPI,
			bookings: *bookingsAPI,
		},
	}

	// Initialize a new http.Server struct.
	serverURI := fmt.Sprintf("%s:%d", *serverAddr, *serverPort)
	srv := &http.Server{
		Addr:         serverURI,
		ErrorLog:     errLog,
		Handler:      app.routes(),
		IdleTimeout:  time.Minute,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	infoLog.Printf("Starting server on %s", serverURI)
	err := srv.ListenAndServe()
	errLog.Fatal(err)
}
