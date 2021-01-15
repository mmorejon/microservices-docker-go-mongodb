package main

import (
	"github.com/gorilla/mux"
)

func (app *application) routes() *mux.Router {
	// Register handler functions.
	r := mux.NewRouter()
	r.HandleFunc("/api/users/", app.all).Methods("GET")
	r.HandleFunc("/api/users/", app.insertUser).Methods("POST")
	r.HandleFunc("/api/users/{id}", app.deleteUser).Methods("DELETE")

	return r
}
