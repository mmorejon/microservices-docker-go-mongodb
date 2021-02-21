package main

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/mmorejon/microservices-docker-go-mongodb/bookings/pkg/models"
)

func (app *application) all(w http.ResponseWriter, r *http.Request) {
	// Get all bookings stored
	bookings, err := app.bookings.All()
	if err != nil {
		app.serverError(w, err)
	}

	// Convert booking list into json encoding
	b, err := json.Marshal(bookings)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Bookings have been listed")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) findByID(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Find booking by id
	m, err := app.bookings.FindByID(id)
	if err != nil {
		if err.Error() == "ErrNoDocuments" {
			app.infoLog.Println("Booking not found")
			return
		}
		// Any other error will send an internal server error
		app.serverError(w, err)
	}

	// Convert booking to json encoding
	b, err := json.Marshal(m)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Have been found a booking")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) insert(w http.ResponseWriter, r *http.Request) {
	// Define booking model
	var m models.Booking
	// Get request information
	err := json.NewDecoder(r.Body).Decode(&m)
	if err != nil {
		app.serverError(w, err)
	}

	// Insert new booking
	insertResult, err := app.bookings.Insert(m)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Printf("New booking have been created, id=%s", insertResult.InsertedID)
}

func (app *application) delete(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Delete booking by id
	deleteResult, err := app.bookings.Delete(id)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Printf("Have been eliminated %d booking(s)", deleteResult.DeletedCount)
}
