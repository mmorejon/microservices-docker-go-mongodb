package main

import (
	"github.com/gorilla/mux"
)

func (app *application) routes() *mux.Router {
	// Register handler functions.
	r := mux.NewRouter()
	r.HandleFunc("/api/bookings/", app.all).Methods("GET")
	r.HandleFunc("/api/bookings/{id}", app.findByID).Methods("GET")
	r.HandleFunc("/api/bookings/", app.insert).Methods("POST")
	r.HandleFunc("/api/bookings/{id}", app.delete).Methods("DELETE")

	return r
}
