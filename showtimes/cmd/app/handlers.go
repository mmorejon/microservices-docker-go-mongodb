package main

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/mmorejon/microservices-docker-go-mongodb/showtimes/pkg/models"
)

func (app *application) all(w http.ResponseWriter, r *http.Request) {
	// Get all showtimes stored
	showtimes, err := app.showtimes.All()
	if err != nil {
		app.serverError(w, err)
	}

	// Convert showtime list into json encoding
	b, err := json.Marshal(showtimes)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Showtimes have been listed")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) findByID(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Find showtime by id
	m, err := app.showtimes.FindByID(id)
	if err != nil {
		if err.Error() == "ErrNoDocuments" {
			app.infoLog.Println("Showtime not found")
			return
		}
		// Any other error will send an internal server error
		app.serverError(w, err)
	}

	// Convert showtime to json encoding
	b, err := json.Marshal(m)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Have been found a showtime")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) findByDate(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	date := vars["date"]

	// Find showtime by date
	m, err := app.showtimes.FindByDate(date)
	if err != nil {
		if err.Error() == "ErrNoDocuments" {
			app.infoLog.Println("Showtime not found")
			return
		}
		// Any other error will send an internal server error
		app.serverError(w, err)
	}

	// Convert showtime to json encoding
	b, err := json.Marshal(m)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Have been found a showtime")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) insert(w http.ResponseWriter, r *http.Request) {
	// Define showtime model
	var m models.ShowTime
	// Get request information
	err := json.NewDecoder(r.Body).Decode(&m)
	if err != nil {
		app.serverError(w, err)
	}

	// Insert new showtime
	m.CreatedAt = time.Now()
	insertResult, err := app.showtimes.Insert(m)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Printf("New showtime have been created, id=%s", insertResult.InsertedID)
}

func (app *application) delete(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Delete showtime by id
	deleteResult, err := app.showtimes.Delete(id)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Printf("Have been eliminated %d showtime(s)", deleteResult.DeletedCount)
}
