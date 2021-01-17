package main

import (
	"github.com/gorilla/mux"
)

func (app *application) routes() *mux.Router {
	// Register handler functions.
	r := mux.NewRouter()
	r.HandleFunc("/api/movies/", app.all).Methods("GET")
	r.HandleFunc("/api/movies/{id}", app.findByID).Methods("GET")
	r.HandleFunc("/api/movies/", app.insert).Methods("POST")
	r.HandleFunc("/api/movies/{id}", app.delete).Methods("DELETE")

	return r
}
