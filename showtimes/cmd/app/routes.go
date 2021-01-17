package main

import (
	"github.com/gorilla/mux"
)

func (app *application) routes() *mux.Router {
	// Register handler functions.
	r := mux.NewRouter()
	r.HandleFunc("/api/showtimes/", app.all).Methods("GET")
	r.HandleFunc("/api/showtimes/{id}", app.findByID).Methods("GET")
	r.HandleFunc("/api/showtimes/filter/date/{date}", app.findByDate).Methods("GET")
	r.HandleFunc("/api/showtimes/", app.insert).Methods("POST")
	r.HandleFunc("/api/showtimes/{id}", app.delete).Methods("DELETE")

	return r
}
